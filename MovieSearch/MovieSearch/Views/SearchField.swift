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
    @ObservedObject var userViewModel: UserViewModel
    @EnvironmentObject var movieStore: MovieStored

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            TextField("Search movies…", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top)

            if viewModel.isLoading && viewModel.searchText.isEmpty {
                ProgressView("Loading recommendations…")
                    .padding()
            }

            // Empty text -> recommendations
            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ScrollView {
                    // Recent searches
                    if !viewModel.recentQueries.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent searches")
                                .font(.headline)
                                .padding(.horizontal)

                            FlexibleChipWrap(viewModel.recentQueries,
                                             onTap: { viewModel.searchText = $0 },
                                             onDelete: { viewModel.removeRecentQuery($0) })
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                    }

                    // Sections
                    VStack(alignment: .leading, spacing: 20) {
                           ForEach(viewModel.recSections) { section in
                               MovieColumn(
                                   title: section.title,
                                   movies: section.movies,
                                   userViewModel: userViewModel
                               )
                           }
                       }
                    .padding(.top, 8)
                }
            } else {
                // Non-empty -> standard results list
                if viewModel.isLoading { ProgressView("Searching…").padding() }
                List(viewModel.movies) { movie in
                    NavigationLink(destination: MovieView(movie: movie,
                                                          userViewModel: userViewModel)) {
                        MovieRow(movie: movie)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onChange(of: viewModel.movies) { oldValue, newValue in
            for movie in newValue {
                if userViewModel.isFavorited(movie),
                   !userViewModel.favoriteMovies.contains(where: { $0.id == movie.id }) {
                    userViewModel.favoriteMovies.append(movie)
                }
            }
            movieStore.movies = newValue
        }
        .navigationTitle("Explore")
    }
}

// Simple chip wrap for recent searches
struct FlexibleChipWrap: View {
    let items: [String]
    var onTap: (String) -> Void
    var onDelete: (String) -> Void

    init(_ items: [String], onTap: @escaping (String) -> Void, onDelete: @escaping (String) -> Void) {
        self.items = items; self.onTap = onTap; self.onDelete = onDelete
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
            ForEach(items.prefix(4), id: \.self) { q in
                HStack(spacing: 6) {
                    Button(q) { onTap(q) }
                        .buttonStyle(.bordered)
                        .controlSize(.small)

                    Button(role: .destructive) { onDelete(q) } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    let mockUser = UserModel(
        id: UUID(),
        name: "Preview User",
        birthday: Date(),
        profileImageData: nil,
        favoriteMovieIDs: []
    )

    let mockViewModel = UserViewModel(user: mockUser)

    return SearchField(userViewModel: mockViewModel)
}
