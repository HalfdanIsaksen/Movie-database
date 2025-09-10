//
//  RecommendationsModel.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 10/09/2025.
//
import Foundation

struct RecommendationSection: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let movies: [Movie]
}
