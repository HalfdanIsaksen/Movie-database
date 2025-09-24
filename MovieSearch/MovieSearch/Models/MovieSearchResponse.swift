//
//  MovieSearchResponse.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 30/04/2025.
//
import Foundation
import Combine

struct MovieSearchResponse: Decodable {
    let results: [Movie]
}

class MovieSearchViewModel: ObservableObject {
    
        @Published var searchText = ""
        @Published var movies: [Movie] = []
        @Published var isLoading = false
        @Published var recommended: [Movie] = []
        @Published var recSections: [RecommendationSection] = []
        @Published var recentQueries: [String] = UserDefaults.standard.stringArray(forKey: "recentQueries") ?? []
        @Published private(set) var favoriteIDs: [Int] = []

        private var cache: [String: [Movie]] = [:]
        private var searchTask: Task<Void, Never>? = nil
        private var cancellables = Set<AnyCancellable>()
        private var recTask: Task<Void, Never>?
        private var recCache: [String: [RecommendationSection]] = [:]
        private var lastRecKey: String?
        private var didBuildDiscover = false
    
        private func key(for ids: [Int]) -> String {
            Array(Set(ids)).sorted().map(String.init).joined(separator: ",")
        }

        init() {
           $searchText
               .debounce(for: .milliseconds(450), scheduler: DispatchQueue.main)
               .removeDuplicates()
               .sink { [weak self] query in
                guard let self else { return }
                   let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                   if trimmed.isEmpty {
                       self.movies = []
                       self.loadRecommendationsIfNeeded(ids: self.favoriteIDs)
                   } else {
                       self.startSearch(query: trimmed)
                   }
               }
               .store(in: &cancellables)
        }
        func setFavoriteIDs(_ ids: [Int]) {
            favoriteIDs = Array(Set(ids)).sorted()
        }
    
        // MARK: - Recents
        func addRecentQuery(_ query: String) {
           let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
           guard !q.isEmpty else { return }
           var set = LinkedHashSet(recentQueries)             // preserves order, removes dups
           set.prepend(q)
           recentQueries = Array(set.prefix(10))
           UserDefaults.standard.set(recentQueries, forKey: "recentQueries")
        }

       func removeRecentQuery(_ query: String) {
           recentQueries.removeAll { $0.caseInsensitiveCompare(query) == .orderedSame }
           UserDefaults.standard.set(recentQueries, forKey: "recentQueries")
       }

       // MARK: - Search
       private func startSearch(query: String) {
           // cancel any in-progress search
           searchTask?.cancel()
           searchTask = Task { await self.searchMovies(query: query) }
       }

       @MainActor private func setLoading(_ v: Bool) { isLoading = v }

       func searchMovies(query: String) async {
           let key = query.lowercased()
           if let cached = cache[key] {
               await MainActor.run { self.movies = cached }
               return
           }

           await setLoading(true)
           defer { Task { await self.setLoading(false) } }

           do {
               guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else { return }
               var components = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!
               components.queryItems = [
                   .init(name: "query", value: query),
                   .init(name: "include_adult", value: "false"),
                   .init(name: "language", value: "en-US"),
                   .init(name: "page", value: "1")
               ]
               var request = URLRequest(url: components.url!)
               request.httpMethod = "GET"
               request.setValue("application/json", forHTTPHeaderField: "accept")
               request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

               let (data, _) = try await URLSession.shared.data(for: request)
               let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

               await MainActor.run {
                   self.movies = response.results
                   self.cache[key] = response.results
                   self.addRecentQuery(query)                 // <— store successful search
               }
           } catch {
               if (error as? URLError)?.code != .cancelled { print("Fetch error:", error) }
           }
       }

    func loadRecommendationsIfNeeded(ids: [Int]) {
            let k = key(for: ids)
            if k == lastRecKey, !recSections.isEmpty { return }          // nothing changed
            if let cached = recCache[k] {                                 // instant reuse
                recSections = cached
                lastRecKey = k
                return
            }
            loadRecommendations(ids: ids)                                 // fetch/build
        }

        func loadRecommendations(ids: [Int]) {
            recTask?.cancel()
            recTask = Task { [weak self] in
                guard let self else { return }
                let k = key(for: ids)

                await MainActor.run { if self.recCache[k] == nil { self.isLoading = true } }
                defer { Task { await MainActor.run { self.isLoading = false } } }

                if ids.isEmpty {
                    if didBuildDiscover, let cached = recCache[""] {
                        await MainActor.run {
                            self.recSections = cached
                            self.lastRecKey = ""
                        }
                        return
                    }
                    await MainActor.run {
                        self.recCache[""] = self.recSections
                        self.lastRecKey = ""
                        self.didBuildDiscover = true
                    }
                    return
                }

                // your existing merge of recommended-for-you
                let lists: [[Movie]] = await withTaskGroup(of: [Movie].self) { group in
                    for id in Set(ids) { group.addTask { [self] in (try? await self.recommendedMovies(id: id)) ?? [] } }
                    var out: [[Movie]] = []; for await x in group { out.append(x) }; return out
                }
                var seen = Set<Int>(), merged: [Movie] = []
                for list in lists { for m in list where seen.insert(m.id).inserted { merged.append(m) } }
                let final = merged.filter { !Set(ids).contains($0.id) }

                await MainActor.run {
                    var sections = self.recSections.filter { $0.title != "Recommended for You" }
                    if !final.isEmpty {
                        sections.insert(RecommendationSection(title: "Recommended for You", movies: final), at: 0)
                    }
                    self.recSections = sections
                    self.recCache[k] = sections
                    self.lastRecKey = k
                }
            }
        }
    
    func trendingMovies() async throws -> [Movie] {
        do {
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return [] // <-- return an empty array instead of nothing
            }
            
            let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "en-US"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 90
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            // Decode JSON into [Movie]
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieSearchResponse.self, from: data)
            return response.results
        } catch {
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for favorited movies")
            } else {
                print("Fetch error: \(error)")
            }
            return [] // <-- ensure function always returns a [Movie]
        }
    }
    
    func popularMovies() async throws -> [Movie] {
        do{
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return [] // <-- return an empty array instead of nothing
            }
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 90
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            // Decode JSON into [Movie]
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieSearchResponse.self, from: data)
            return response.results
        }catch{
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for favorited movies")
            } else {
                print("Fetch error: \(error)")
            }
            return []
        }
    }
    func topratedMovies() async throws -> [Movie] {
        do{
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return [] // <-- return an empty array instead of nothing
            }
            let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 90
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieSearchResponse.self, from: data)
            return response.results
        }catch{
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for favorited movies")
            } else {
                print("Fetch error: \(error)")
            }
            return []
        }
    }
    
    func upcomingMovies() async throws-> [Movie] {
        do{
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return []
            }
            let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "en-US"),
              URLQueryItem(name: "page", value: "1"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieSearchResponse.self, from: data)
            return response.results
        }catch{
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for favorited movies")
            } else {
                print("Fetch error: \(error)")
            }
            return []
        }
    }
    
    func recommendedMovies(id: Int) async throws -> [Movie] {
        do{
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return []
            }
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/recommendations")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "language", value: "en-US"),
              URLQueryItem(name: "page", value: "1"),
            ]
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(MovieSearchResponse.self, from: data)
            return response.results
            
        }catch{
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for favorited movies")
            } else {
                print("Fetch error: \(error)")
            }
            return []
        }
    }
}

fileprivate struct LinkedHashSet<Element: Hashable>: Sequence {
    private var seen = Set<Element>()
    private var items: [Element] = []
    init(_ array: [Element]) { array.forEach { append($0) } }
    mutating func append(_ e: Element) { if seen.insert(e).inserted { items.append(e) } }
    mutating func prepend(_ e: Element) { if seen.insert(e).inserted { items.insert(e, at: 0) }
        else { items.removeAll { $0 == e }; items.insert(e, at: 0) } }
    func prefix(_ n: Int) -> [Element] { Array(items.prefix(n)) }
    func makeIterator() -> IndexingIterator<[Element]> { items.makeIterator() }
}
