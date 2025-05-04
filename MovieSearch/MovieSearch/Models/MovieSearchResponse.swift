//
//  MovieSearchResponse.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 30/04/2025.
//
import Foundation

struct MovieSearchResponse: Decodable {
    let results: [Movie]
}

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let original_title: String
    let overview: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double
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
