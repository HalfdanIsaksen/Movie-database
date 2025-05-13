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

    private var debounceTask: Task<Void, Never>?

    init() {
        // Debounce text input changes
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.movies = []
                    return
                }
                self?.debounceTask?.cancel()
                self?.debounceTask = Task {
                    await self?.searchMovies(query: query)
                }
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    func searchMovies(query: String) async {
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
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

            // Update on main thread
            await MainActor.run {
                self.movies = response.results
            }
        } catch {
            print("Fetch error: \(error)")
        }
    }
}

func searchMovies(query: String, language: String = "en-US") async{
    do{
        guard let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String else {
                    print("API Key not found in Info.plist")
                    return
        }
        
        let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "true"),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        print(String(decoding: data, as: UTF8.self))
    }catch{
        print("Error fetching movie data: \(error)")
    }
    
}
