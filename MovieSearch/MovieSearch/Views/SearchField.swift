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
        @EnvironmentObject var favoritesVM: FavoritesViewModel

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
                            favoritesVM.toggleFavorite(movie)
                        }) {
                            Image(systemName: favoritesVM.isFavorited(movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
}
#Preview {
    SearchField()
}
