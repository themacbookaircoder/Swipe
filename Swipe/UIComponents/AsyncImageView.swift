//
//  AsyncImageView.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct AsyncImageView: View {
    
    // MARK: - Properties
    let urlString: String?
    
    // MARK: - Body
    var body: some View {
        if let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) {
            WebImage(url: url)
                .resizable()
                .indicator(.activity)
                .scaledToFill()
        } else {
            LinearGradient(gradient: Gradient(colors: [Color.random(), Color.random(), Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

public extension Color {

    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}
