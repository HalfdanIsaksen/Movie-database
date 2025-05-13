//
//  Movie.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 30/04/2025.
//

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let original_title: String
    let overview: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double
}
