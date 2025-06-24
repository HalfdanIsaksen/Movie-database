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

    var body: some View {
        VStack(alignment: .leading){
            //MovieColumn(title: "Recommended for You", movies: recommendedMovies, userViewModel: userViewModel)
            MovieColumn(title: "Trending", movies: trendingMovies, userViewModel: userViewModel)
            MovieColumn(title: "Popular", movies: <#T##[Movie]#>, userViewModel: <#T##UserViewModel#>)
        }
        .navigationTitle("Home")
        .task {
            // Run when the view appears
            trendingMovies = (try? await movieSearchModel.trendingMovies()) ?? []
            
        }
    }
}
