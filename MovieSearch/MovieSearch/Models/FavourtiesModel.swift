//
//  FavourtiesModel.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//
import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Movie] = []

    private let storageKey = "favorited_movies"

    init() {
        loadFavorites()
    }

    func isFavorited(_ movie: Movie) -> Bool {
        favorites.contains(where: { $0.id == movie.id })
    }

    func toggleFavorite(_ movie: Movie) {
        if isFavorited(movie) {
            favorites.removeAll { $0.id == movie.id }
        } else {
            favorites.append(movie)
        }
        saveFavorites()
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Movie].self, from: data) else {
            return
        }
        favorites = saved
    }
}
