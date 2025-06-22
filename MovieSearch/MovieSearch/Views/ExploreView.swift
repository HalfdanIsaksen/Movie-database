//
//  Explore.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/06/2025.
//

import SwiftUI

struct ExploreView: View {
    let recommendedMovies: [Movie]
    @State var trendingMovies: [Movie]
    let userViewModel: UserViewModel
    let movieSearchModel: MovieSearchViewModel
    
    var body: some View {
        trendingMovies = movieSearchModel.trendingMovies()
        
        VStack(alignment: .leading){
            MovieColumn(title: "Recommended for You", movies: recommendedMovies, userViewModel: userViewModel)
            MovieColumn(title: "Trending", movies: trendingMovies, userViewModel: userViewModel)
        }
        .navigationTitle("Home")
    }
}
