//
//  User.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 15/05/2025.
//

import SwiftUI
import UIKit

struct UserInfoView: View {
        @Binding var user: UserModel
        @State private var isImagePickerPresented = false
        @State private var inputImage: UIImage?

        var profileImage: Image {
        if let data = user.profileImageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
            } else {
                return Image(systemName: "person.circle")
            }
        }

        var body: some View {
           HStack {
               profileImage
                   .resizable()
                   .scaledToFit()
                   .frame(width: 100, height: 100)
                   .clipShape(Circle())
                   .onTapGesture {
                       isImagePickerPresented = true
                   }

               VStack(alignment: .leading) {
                   TextField("Enter your name", text: $user.name)
                       .font(.headline)

                   DatePicker("Birthday", selection: $user.birthday, displayedComponents: .date)
                       .font(.subheadline)
               }
           }
           .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
               ImagePicker(image: $inputImage)
           }
        }

        private func loadImage() {
           guard let inputImage = inputImage else { return }
           user.profileImageData = inputImage.jpegData(compressionQuality: 0.8)
        }
}
