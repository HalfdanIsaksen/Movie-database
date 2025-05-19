//
//  LoginView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 19/05/2025.
//

import SwiftUI

struct LoginView: View {
    var onLogin: (User) -> Void

    @State private var name = ""
    @State private var birthday = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome")
                .font(.largeTitle)

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)

            Button("Log In / Register") {
                let newUser = User(name: name, birthday: birthday, profileImageData: nil, favoriteMovieIDs: [])
                onLogin(newUser)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
