//
//  Explore.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/06/2025.
//

import SwiftUI

struct ExploreView: View {
    let movies: [Movie]
    let userViewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            MovieColumn(title: "Recommended for You", movies: movies, userViewModel: userViewModel)
        }
        .navigationTitle("Home")
    }
}
