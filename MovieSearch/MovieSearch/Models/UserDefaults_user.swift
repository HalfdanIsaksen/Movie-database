//
//  UserDefaults_user.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 21/05/2025.
//

import Foundation

extension UserDefaults {
    private static let userKey = "storedUser"

    func saveUser(_ user: UserModel) {
        if let encoded = try? JSONEncoder().encode(user) {
            set(encoded, forKey: Self.userKey)
        }
    }

    func loadUser() -> UserModel? {
        if let data = data(forKey: Self.userKey),
           let decoded = try? JSONDecoder().decode(UserModel.self, from: data) {
            return decoded
        }
        return nil
    }
}

