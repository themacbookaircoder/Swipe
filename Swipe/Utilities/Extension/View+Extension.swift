//
//  View+Extension.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation
import SwiftUI

extension View {
    
    func textStyle(
        color: Color = .black,
        font: Font = .body,
        weight: Font.Weight = .regular,
        alignment: TextAlignment = .center) -> some View {
        self.modifier(TextStyleModifier(color: color, font: font, weight: weight, alignment: alignment))
    }
    
    var cardModifier: some View {
        self.modifier(CardModifier())
    }
}
    
