//
//  MovieView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 12/06/2025.
//

import Foundation
import SwiftUI
import Combine

struct MovieView: View {
    let movie: Movie
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let path = movie.poster_path,
                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(movie.title)
                    .font(.title)
                    .bold()

                Text("Release Date: \(movie.release_date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Rating: \(String(format: "%.1f", movie.vote_average))/10")
                    .font(.subheadline)
                    .foregroundColor(.orange)

                Text(movie.overview)
                    .font(.body)
                    .padding(.top)

                Button(action: {
                    userViewModel.toggleFavorite(movie)
                }) {
                    Label(userViewModel.isFavorited(movie) ? "Remove from Favorites" : "Add to Favorites",
                          systemImage: userViewModel.isFavorited(movie) ? "heart.fill" : "heart")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(10)
                }
                .foregroundColor(.red)
            }
            .padding()
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
