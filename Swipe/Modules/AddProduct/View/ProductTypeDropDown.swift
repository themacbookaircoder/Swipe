//
//  ProductTypeDropDown.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI

struct ProductTypeDropDown: View {
    
    // MARK: - Properties
    @Binding var selectedOption: String
    @Binding var showDropDown: Bool
    let options: [String]
    let placeholder: String
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.white.opacity(0.6))
                    .strokeBorder(Color.secondary, lineWidth: 0.5)
                    .shadow(radius: 5, x: 2, y: 0)
                    .frame(height: 50)
                
                HStack {
                    Text(selectedOption.isEmpty ? placeholder : selectedOption)
                        .foregroundColor(selectedOption.isEmpty ? .white : .primary)
                        .font(.system(.body, weight: .medium))
                    Spacer()
                    Image(systemName: showDropDown ? "chevron.up" : "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.secondary)
                }
                .padding(.horizontal)
            }
            .onTapGesture {
                withAnimation {
                    showDropDown.toggle()
                }
            }

            if showDropDown {
                DropDownList(
                    selectedOption: $selectedOption,
                    showDropDown: $showDropDown,
                    options: options
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

struct DropDownList: View {
    @Binding var selectedOption: String
    @Binding var showDropDown: Bool
    let options: [String]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.pink.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.pink.opacity(0.5), lineWidth: 0.5)
                )
            ScrollView(.vertical) {
                VStack(spacing: 17) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            withAnimation {
                                selectedOption = option
                                showDropDown = false
                            }
                        } label: {
                            HStack {
                                Text(option)
                                    .font(.system(.subheadline, weight: .medium))
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 15)
            }
        }
        .frame(height: 200)
    }
}
