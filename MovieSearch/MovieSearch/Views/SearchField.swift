//
//  SearchField.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 03/05/2025.
//
import Foundation
import SwiftUI

struct SearchField: View {
    @State var searchText: String = ""
    var body: some View {
        TextField("Search...", text: $searchText)
            .onChange(of: searchText) { newValue in
                            Task {
                                await searchMovies(query: newValue)
                            }
                        }
    }
}
#Preview {
    SearchField()
}
