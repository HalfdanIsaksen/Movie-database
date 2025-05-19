//
//  ContentView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 29/04/2025.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject var favoritesVM = FavoritesViewModel()
    @State private var loggedInUser: UserModel? = nil
    // Dummy user and movies for now
        private let testUser = UserModel(
            id: UUID(),
            name: "Halfdan",
            birthday: Date(timeIntervalSince1970: 315532800), // 1980-01-01
            profileImageData: nil,
            favoriteMovieIDs: [1, 2]
        )
    var testMovies: [Movie] = []
    var body: some View {
            TabView {
                SearchField()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }

                Group {
                    if let user = loggedInUser {
                        UserView(viewModel: UserViewModel(user: user), allMovies: testMovies)
                    } else {
                        LoginView(onLogin: { user in
                            self.loggedInUser = user
                        })
                    }
                }
                .tabItem {
                    Label("User", systemImage: "person.circle")
                }
            }
            .environmentObject(favoritesVM)
        }
}

#Preview {
    ContentView()
}
