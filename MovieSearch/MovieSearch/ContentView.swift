//
//  ContentView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var favoritesVM = FavoritesViewModel()
    var body: some View {
        TabView {
        SearchField()
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

        UserView()
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
