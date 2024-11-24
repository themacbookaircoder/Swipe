//
//  AddProductView.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI


enum FocusableField: Hashable {
    case productName, productPrice, productTax
}

struct AddProductView: View {
  
    // MARK: - Properties
    @Environment(\.modelContext) var modelContext
    @State private var viewModel: AddProductViewModel
    @State private var showDropDown: Bool = false
    @Environment(\.dismiss) var dismiss
    let completion: (() -> Void)?
    
    // MARK: - Init
    init(productType:[String], completion: (() -> Void)? = nil) {
        self._viewModel = State(wrappedValue: AddProductViewModel(productTypes: productType))
        self.completion = completion
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            contentView
            if viewModel.showLoader {
                Loader()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            viewModel.modelContext = modelContext
        }
    }
}

extension AddProductView {
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .textStyle(color: .pink, font: .headline, weight: .bold)
                }
            }
            ProductTypeDropDown(
                selectedOption: $viewModel.productType,
                showDropDown: $showDropDown,
                options: viewModel.productTypes,
                placeholder: "Select Product Type"
            )
            CustomTextField(configuration: .productName, text: $viewModel.productName)
            CustomTextField(configuration: .productPrice, text: $viewModel.productPrice)
            CustomTextField(configuration: .productTax, text: $viewModel.productTax)
            Spacer()
            CustomButton(title: "Add Product") {
                Task {
                    await viewModel.addProduct()
                    if (viewModel.addProductResponse?.success ?? false) {
                        dismiss()
                        completion?()
                    }
                }
            }
            .disabled(!viewModel.validAddProduct())
            .opacity(viewModel.validAddProduct() ? 1 : 0.5)
        }
        .padding(.all)
    }
}

#Preview {
    AddProductView(productType: [])
}
