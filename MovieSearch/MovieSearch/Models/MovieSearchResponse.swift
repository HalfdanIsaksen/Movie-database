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
    
    private var cache: [String: [Movie]] = [:]

    private var searchTask: Task<Void, Never>? = nil

    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                self?.startSearch(query: newQuery)
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    private func startSearch(query: String) {
        guard !query.isEmpty else {
            movies = []
            return
        }

        // Cancel any in-progress search
        searchTask?.cancel()

        // Launch a new task
        searchTask = Task {
            await self.searchMovies(query: query)
        }
    }

    func searchMovies(query: String) async {
        if let cached = cache[query.lowercased()] {
                await MainActor.run {
                    self.movies = cached
                }
                return
            }

            await MainActor.run { self.isLoading = true }
            defer { Task { await MainActor.run { self.isLoading = false } } }
        
        do {
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return
            }

            var components = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!
            components.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1")
            ]

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.timeoutInterval = 90
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

            await MainActor.run {
                self.movies = response.results
                self.cache[query.lowercased()] = response.results // <-- Save to cache
            }
        } catch {
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for query: \(query)")
            } else {
                print("Fetch error: \(error)")
            }
        }
    }
    
    func trendingMovies() async throws -> [Movie] {
        
        do{
            guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                print("API Key missing.")
                return []
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
        }catch {
            if (error as? URLError)?.code == .cancelled {
                print("Search cancelled for favorited movies")
            } else {
                print("Fetch error: \(error)")
            }
            return []
        }
    }
}
