//
//  MovieCardView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 16/06/2025.
//
import SwiftUI

struct MovieCard: View {
    let movie: Movie

    var body: some View {
        VStack {
            if let path = movie.poster_path,
               let url = URL(string: "https://image.tmdb.org/t/p/w200\(path)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 120, height: 180)
                .cornerRadius(10)
            } else {
                Color.gray
                    .frame(width: 120, height: 180)
                    .cornerRadius(10)
            }

            Text(movie.title)
                .font(.caption)
                .frame(width: 120)
                .lineLimit(1)
        }
    }
}
