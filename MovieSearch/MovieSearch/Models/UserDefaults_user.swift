//
//  UserDefaults_user.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 21/05/2025.
//

import Foundation

extension UserDefaults {
    private static let userKey = "currentUser"

    func saveUser(_ user: UserModel) {
        if let data = try? JSONEncoder().encode(user) {
            set(data, forKey: Self.userKey)
        }
    }

    func loadUser() -> UserModel? {
        guard let data = data(forKey: Self.userKey),
              let user = try? JSONDecoder().decode(UserModel.self, from: data) else {
            return nil
        }
        return user
    }

    func removeUser() {
        removeObject(forKey: Self.userKey)
    }
}

