//
//  ContentView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 29/04/2025.
//

import SwiftUI
import Foundation

struct ContentView: View {

    @State private var loggedInUser: UserModel? = UserDefaults.standard.loadUser()
    
    @StateObject private var userViewModel = UserViewModel(
           user: UserDefaults.standard.loadUser() ?? UserModel(
               id: UUID(),
               name: "Default",
               birthday: Date(),
               profileImageData: nil,
               favoriteMovieIDs: []
           )
       )
    @StateObject private var movieStore = MovieStored()
    // Dummy user and movies for now
       /* private let testUser = UserModel(
            id: UUID(),
            name: "Halfdan",
            birthday: Date(timeIntervalSince1970: 315532800), // 1980-01-01
            profileImageData: nil,
            favoriteMovieIDs: [1, 2]
        )
    var testMovies: [Movie] = []*/
    var body: some View {
        TabView {
            NavigationView{
                ExploreView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            NavigationView {
                SearchField(userViewModel: userViewModel)
                    .environmentObject(movieStore)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationView {
                UserView(viewModel: userViewModel, allMovies: movieStore.movies)
                    .environmentObject(movieStore)
            }
            .tabItem {
                Label("User", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
