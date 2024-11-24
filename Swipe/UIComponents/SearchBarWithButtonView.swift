//
//  SearchBarWithButtonView.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    
    // MARK: - Properties
    @Binding var searchText: String
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 10){
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.gray.opacity(0.2))
                    .shadow(radius: 5, x: 2, y: 0)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)
                    
                    TextField("Search by Product", text: $searchText)
                        .textFieldStyle(.plain)
                        .foregroundStyle(Color.white)
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 50)
        }
    }
}
