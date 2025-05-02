//
//  ContentView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Movie Search")
                        .onAppear {
                            Task {
                                await searchMovies(query: "Leon the professional")
                            }
                        }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
