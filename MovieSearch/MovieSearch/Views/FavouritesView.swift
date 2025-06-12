//
//  FavouritesView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//

//Might be able to delete this isnt currently used

import SwiftUI

struct FavoritesView: View {
    var movies: [Movie]
    @StateObject var viewModel: UserViewModel
    var body: some View {
        VStack {
            if movies.isEmpty {
                Text("No favorite movies yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(movies) { movie in
                    NavigationLink(destination: MovieView(movie: movie, userViewModel: viewModel)) {
                        MovieRow(movie: movie)
                    }
                }
            }
        }
    }
}
