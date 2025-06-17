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
    @EnvironmentObject var movieStore: MovieStored

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
                    NavigationLink(destination: MovieView(movie: movie, userViewModel: userViewModel)) {
                        MovieRow(movie: movie)
                    }
                }
            }
            .onChange(of: viewModel.movies) {
                for movie in viewModel.movies {
                    if userViewModel.isFavorited(movie),
                       !userViewModel.favoriteMovies.contains(where: { $0.id == movie.id }) {
                        userViewModel.favoriteMovies.append(movie)
                    }
                }
                movieStore.movies = viewModel.movies
            }
        .navigationTitle("Explore")
        

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
