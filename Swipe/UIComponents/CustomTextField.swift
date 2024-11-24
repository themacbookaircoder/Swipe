//
//  CustomTextField.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI

struct CustomTextField: View {
    
    // MARK: - Properties
    let configuration: TextFieldConfiguration
    @Binding var text: String
    @FocusState var isFocused: FocusableField?

    // MARK: - Body
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.gray.opacity(0.2))
                .strokeBorder(Color.secondary, lineWidth: 0.5)
                .shadow(radius: 5, x: 2, y: 0)
                .frame(height: 50)
            
            TextField(configuration.placeholder, text: $text)
                .textFieldStyle(.plain)
                .focused($isFocused, equals: configuration.focusedField)
                .keyboardType(configuration.keyboardType)
                .padding(.horizontal, 10)
                .foregroundStyle(Color.white)
        }
        .frame(height: 50)
    }
}

enum TextFieldConfiguration {
    case productName
    case productPrice
    case productTax
    
    var placeholder: String {
        switch self {
        case .productName:
            return "Product Name"
        case .productPrice:
            return "Product Price"
        case .productTax:
            return "Product Tax"
        }
    }
    
    var focusedField: FocusableField {
        switch self {
        case .productName:
            return .productName
        case .productPrice:
            return .productPrice
        case .productTax:
            return .productTax
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .productName:
            return .default
        case .productPrice, .productTax:
            return .decimalPad
        }
    }
}
