//
//  AddProductViewModel.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI
import SwiftData


@Observable
final class AddProductViewModel {
    
    
    // MARK: -
    let productTypes: [String]
    var productType: String = ""
    var productName: String = ""
    var productPrice:  String = ""
    var productTax:  String = ""
    var addProductResponse: AddProductResponse?
    var showLoader: Bool = false
    var modelContext:ModelContext? = nil
    
    // MARK: - Init
    init (productTypes: [String]) {
        self.productTypes = productTypes
    }
   
}

// MARK: - Helpers
extension AddProductViewModel {
    
    func validAddProduct() -> Bool {
        guard
            !productType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let price = Double(productPrice), price > 0,
            let tax = Double(productTax), tax >= 0
        else {
            print("Error: Please ensure the following:")
            print("- Product type must be selected.")
            print("- Product name cannot be empty.")
            print("- Product price must be a valid number greater than 0.")
            print("- Product tax must be a valid number and cannot be negative.")
            return false
        }

        return true
    }

    
//    func addProduct() async {
//        showLoader = true
//        do {
//            let request = ProductRequest(productName: productName, productType: productType, price: productPrice.toDouble(), tax: productTax.toDouble())
//            addProductResponse = try await APIClient.sendRequest(endPoint: .addProduct(request))
//            showLoader = false
//        } catch {
//            showLoader = false
//            print("Error: \(error)")
//        }
//    }
    
    func addProduct() async {
        showLoader = true
        let request = ProductRequest(productName: productName, productType: productType, price: productPrice.toDouble(), tax: productTax.toDouble())
        if NetworkMonitor.shared.isConnected() {
            do {
                addProductResponse = try await APIClient.sendRequest(endPoint: .addProduct(request))
                print("Product added successfully.")
            } catch {
                print("Failed to add product online. Saving locally.")
                saveProductRequestLocally(productRequest: request)
            }
        } else {
            print("No network connection. Saving product locally.")
            saveProductRequestLocally(productRequest: request)
        }
        showLoader = false
    }
}

extension AddProductViewModel {
    func saveProductRequestLocally(productRequest: ProductRequest) {
        let entity = ProductRequestEntity(
            productName: productRequest.productName,
            productType: productRequest.productType,
            price: productRequest.price,
            tax: productRequest.tax
        )
        
        do {
            modelContext?.insert(entity)
            try modelContext?.save()
            print("Product request saved locally.")
        } catch {
            print("Failed to save product request locally: \(error)")
        }
    }
}
