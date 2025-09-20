//
//  RecommendationsModel.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 10/09/2025.
//
import Foundation

struct RecommendationSection: Identifiable, Equatable {
    let id: String           // stable key
    let title: String
    let movies: [Movie]

    init(title: String, movies: [Movie]) {
        self.title = title
        self.movies = movies
        self.id = title.lowercased()
    }
}
