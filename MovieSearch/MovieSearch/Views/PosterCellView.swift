//
//  PosterCellView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 18/09/2025.
//
import SwiftUI

struct PosterCell: View {
    let movie: Movie
    let userViewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Poster image fills the cell
            if let path = movie.poster_path,
               let url = URL(string: "https://image.tmdb.org/t/p/w200\(path)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle().fill(.secondary.opacity(0.2))
                    }
                }

            // Title overlay (optional)
            LinearGradient(colors: [.black.opacity(0.0), .black.opacity(0.6)], startPoint: .center, endPoint: .bottom)
            Text(movie.title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(8)
        }
        .contentShape(Rectangle())
        .onTapGesture {  }
    }
}
