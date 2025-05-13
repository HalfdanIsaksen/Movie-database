//
//  SearchField.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 03/05/2025.
//
import Foundation
import SwiftUI

struct SearchField: View {
    @StateObject private var viewModel = MovieSearchViewModel()

       var body: some View {
           VStack {
               TextField("Search movies...", text: $viewModel.searchText)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding()

               List(viewModel.movies) { movie in
                   MovieRow(movie: movie)
               }
           }
       }
}
#Preview {
    SearchField()
}
