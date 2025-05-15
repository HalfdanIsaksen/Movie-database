//
//  UserModel.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 16/05/2025.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Codable {
    var id: UUID
    var name: String
    var birthday: Date
    var profileImageData: Data? // Store UIImage as Data
    var favoriteMovieIDs: [Int] // Assuming Movie has an Int id
}

class UserViewModel: ObservableObject {
    @Published var user: UserModel

    init(user: UserModel) {
        self.user = user
    }

    var profileImage: Image {
        if let data = user.profileImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.circle")
        }
    }

    func updateImage(_ image: UIImage) {
        user.profileImageData = image.jpegData(compressionQuality: 0.8)
    }
}
