//
//  SearchField.swift
//  MovieSearch
//
//  Created by Halfdan Albrecht Isaksen on 03/05/2025.
//

import SwiftUI

struct SearchField: View {
    @State var searchText: String = ""
    var body: some View {
        TextField("Search...", text: $searchText)
    }
}
#Preview {
    SearchField()
}
