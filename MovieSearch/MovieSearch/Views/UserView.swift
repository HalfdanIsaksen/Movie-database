//
//  UserView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//
import SwiftUI

struct UserView: View {
    @StateObject var viewModel: UserViewModel
       var allMovies: [Movie]

       var body: some View {
           VStack(alignment: .leading, spacing: 20) {
               UserInfoView(user: $viewModel.user)

               Divider()

               Text("Favorite Movies")
                   .font(.title2)
                   .bold()

               FavoritesView(movies: viewModel.favoriteMovies, viewModel: viewModel)

               Spacer()
           }
           .padding()
           .navigationTitle("User Profile")
           
       }

       private var favoriteMovies: [Movie] {
           print("All movies count: \(allMovies.count)")

           return allMovies.filter { viewModel.user.favoriteMovieIDs.contains($0.id) }
           
       }
}
