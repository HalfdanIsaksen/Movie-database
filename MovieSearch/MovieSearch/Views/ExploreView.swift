//
//  Explore.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/06/2025.
//

import SwiftUI

struct ExploreView: View {
    //let recommendedMovies: [Movie]
    @ObservedObject var userViewModel: UserViewModel
    @StateObject private var movieSearchModel = MovieSearchViewModel()

    @State private var trendingMovies: [Movie] = []
    @State private var popularMovies: [Movie] = []
    @State private var topRatedMovies: [Movie] = []
    @State private var upcomingMovies: [Movie] = []

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 20) {
                    //MovieColumn(title: "Recommended for You", movies: recommendedMovies, userViewModel: userViewModel)
                    MovieColumn(title: "Upcoming Movies", movies: upcomingMovies, userViewModel: userViewModel)
                    MovieColumn(title: "Trending", movies: trendingMovies, userViewModel: userViewModel)
                    MovieColumn(title: "Popular", movies: popularMovies, userViewModel: userViewModel)
                    MovieColumn(title: "Top Rated", movies: topRatedMovies, userViewModel: userViewModel)
                }
                .padding(.vertical)
            }
        .navigationTitle("Home")
        .task {
            // Run when the view appears
            upcomingMovies = (try? await movieSearchModel.upcomingMovies()) ?? []
            trendingMovies = (try? await movieSearchModel.trendingMovies()) ?? []
            popularMovies  = (try? await movieSearchModel.popularMovies()) ?? []
            topRatedMovies = (try? await movieSearchModel.topratedMovies()) ?? []
            
        }
    }
}
