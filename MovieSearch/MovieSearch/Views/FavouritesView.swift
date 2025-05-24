//
//  FavouritesView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//

//Might be able to dele this isnt currently used

import SwiftUI

struct FavoritesView: View {
    var movies: [Movie]

    var body: some View {
        VStack {
            if movies.isEmpty {
                Text("No favorite movies yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(movies) { movie in
                    MovieRow(movie: movie)
                }
            }
        }
    }
}
