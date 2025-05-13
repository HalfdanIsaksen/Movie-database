//
//  FavouritesView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        VStack {
            if favoritesVM.favorites.isEmpty {
                Text("No favorite movies yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(favoritesVM.favorites) { movie in
                    MovieRow(movie: movie)
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
