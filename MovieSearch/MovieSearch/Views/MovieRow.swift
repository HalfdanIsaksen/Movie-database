//
//  MovieRow.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//
import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top) {
            Group {
                if let path = movie.poster_path,
                   let url = URL(string: "https://image.tmdb.org/t/p/w200\(path)") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Color.gray // Fallback for missing image
                }
            }
            .frame(width: 60, height: 90)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.release_date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(movie.overview)
                    .font(.caption)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 4)
    }
}
