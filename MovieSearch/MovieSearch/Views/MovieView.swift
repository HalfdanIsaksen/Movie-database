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
                    withAnimation(.easeInOut) {
                        userViewModel.toggleFavorite(movie)
                    }
                }) {
                    Label(
                        title: {
                            Text(userViewModel.isFavorited(movie) ? "Remove from Favorites" : "Add to Favorites")
                                .transition(.opacity) // Fades the text
                        },
                        icon: {
                            Image(systemName: userViewModel.isFavorited(movie) ? "heart.fill" : "heart")
                                .scaleEffect(userViewModel.isFavorited(movie) ? 1.2 : 1.0)
                                .animation(.easeInOut, value: userViewModel.isFavorited(movie))
                        }
                    )
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
