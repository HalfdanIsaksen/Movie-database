//
//  UserModel.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 16/05/2025.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Codable {
    var id: UUID
    var name: String
    var birthday: Date
    var profileImageData: Data? // Store UIImage as Data
    var favoriteMovieIDs: [Int] // Assuming Movie has an Int id
}

class UserViewModel: ObservableObject {
    @Published var user: UserModel
    @Published var favoriteMovies: [Movie] = []
    
    private let favoriteMovieKey = "favoriteMovies"
    
    init() {
           if let savedUser = UserDefaults.standard.loadUser() {
               self.user = savedUser
           } else {
               self.user = UserModel(
                   id: UUID(),
                   name: "Guest",
                   birthday: Date(),
                   profileImageData: nil,
                   favoriteMovieIDs: []
               )
           }
       }

        init(user: UserModel) {
            self.user = user
            loadFavoriteMovies()
        }

    var profileImage: Image {
        if let data = user.profileImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.circle")
        }
    }

    func updateImage(_ image: UIImage) {
        user.profileImageData = image.jpegData(compressionQuality: 0.8)
    }

    func isFavorited(_ movie: Movie) -> Bool {
        user.favoriteMovieIDs.contains(movie.id)
    }

    func toggleFavorite(_ movie: Movie) {
        if isFavorited(movie) {
            user.favoriteMovieIDs.removeAll { $0 == movie.id }
            favoriteMovies.removeAll { $0.id == movie.id }
        } else {
            user.favoriteMovieIDs.append(movie.id)
            if !favoriteMovies.contains(where: { $0.id == movie.id }) {
                favoriteMovies.append(movie)
            }
        }
        saveUser()
        saveFavoriteMovies()
    }

    func saveFavoriteMovies() {
        if let encoded = try? JSONEncoder().encode(favoriteMovies) {
            UserDefaults.standard.set(encoded, forKey: favoriteMovieKey)
        }
    }

    func loadFavoriteMovies() {
        if let data = UserDefaults.standard.data(forKey: favoriteMovieKey),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            favoriteMovies = decoded

            // Also update the IDs to stay consistent
            user.favoriteMovieIDs = decoded.map { $0.id }
        }
    }

    func saveUser() {
        UserDefaults.standard.saveUser(user)
    }
}

