//
//  MovieColumn.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 15/06/2025.
//

import SwiftUI

struct MovieColumn: View{
    let title: String
        let movies: [Movie]
        let userViewModel: UserViewModel

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .padding(.leading, 8)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(movies) { movie in
                            NavigationLink(destination: MovieView(movie: movie, userViewModel: userViewModel)) {
                                MovieCard(movie: movie)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
}
