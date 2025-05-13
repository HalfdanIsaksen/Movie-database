//
//  UserView.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 13/05/2025.
//
import SwiftUI

struct UserView: View {
    var body: some View {
        VStack{
            Text("UserView")
                .font(.title)
                .padding(.top)
            FavoritesView()
        }
    }
}
