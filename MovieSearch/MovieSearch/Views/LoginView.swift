//
//  LoginView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 19/05/2025.
//

import SwiftUI

struct LoginView: View {
    var onLogin: (UserModel) -> Void

    @State private var name = ""
    @State private var birthday = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("Login to see your favorite movies")
                .font(.title)

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)

            Button("Log In / Register") {
                let newUser = UserModel(id: UUID(), name: name, birthday: birthday, profileImageData: nil, favoriteMovieIDs: [])
                onLogin(newUser)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
