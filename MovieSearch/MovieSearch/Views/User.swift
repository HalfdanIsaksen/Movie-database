//
//  User.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 15/05/2025.
//

import SwiftUI
struct User: View {
    @State private var name: String = ""
        @State private var birthday: Date = Date()
        @State private var profileImage: Image? = Image(systemName: "person.circle")
        @State private var isImagePickerPresented = false
        @State private var inputImage: UIImage?

        var favoriteMovies: [Movie] // Assumes Movie is already defined in the project

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                // User Profile Section
                HStack {
                    profileImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .onTapGesture {
                            isImagePickerPresented = true
                        }

                    VStack(alignment: .leading) {
                        TextField("Enter your name", text: $name)
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                            .font(.subheadline)
                    }
                }
                .padding()

                Divider()

                // Favorite Movies Section
                Text("Favorite Movies")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                FavoriteMoviesView(movies: favoriteMovies)

                Spacer()
            }
            .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .padding()
            .navigationTitle("User Profile")
        }

        func loadImage() {
            guard let inputImage = inputImage else { return }
            profileImage = Image(uiImage: inputImage)
        }
}
