//
//  CustomButton.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI

import SwiftUI

struct CustomButton: View {
    
    // MARK: - Properties
    let title: String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.pink.opacity(0.8))
                    .shadow(radius: 5, x: 2, y: 0)
                    .frame(height: 50)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(.body, weight: .semibold))
            }
        }
        .frame(height: 50)
    }
}


#Preview {
    CustomButton(title: "", action: {
        
    })
}
