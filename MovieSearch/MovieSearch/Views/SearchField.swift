//
//  SearchField.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 03/05/2025.
//
import Foundation
import SwiftUI

struct SearchField: View {
    @StateObject private var viewModel = MovieSearchViewModel()
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        VStack {
            TextField("Search movies...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if viewModel.isLoading {
                ProgressView("Searching...")
                    .padding()
            }

            List(viewModel.movies) { movie in
                HStack {
                    MovieRow(movie: movie)
                    Spacer()
                    Button(action: {
                        userViewModel.toggleFavorite(movie)
                    }) {
                        Image(systemName: userViewModel.isFavorited(movie) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    let mockUser = UserModel(
        id: UUID(),
        name: "Preview User",
        birthday: Date(),
        profileImageData: nil,
        favoriteMovieIDs: []
    )

    let mockViewModel = UserViewModel(user: mockUser)

    return SearchField(userViewModel: mockViewModel)
}
