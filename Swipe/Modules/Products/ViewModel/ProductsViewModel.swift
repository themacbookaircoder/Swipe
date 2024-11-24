//
//  ProductsViewModel.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation
import SwiftData
import Combine

@Observable
final class ProductsViewModel {
    
    // MARK: - Properties
    var viewState: ViewState<[Products]> = .initial
    var products:[Products]?
    var modelContext:ModelContext? = nil
    var searchText:String = ""
    var addProduct: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeNetworkChanges()
    }
    
}

// MARK: - Helpers
extension ProductsViewModel {
   
    func getProducts() async {
        viewState = .fetching
        do {
            do {
                try modelContext?.delete(model: Products.self)
            } catch {
                print("Failed to delete all Categories.")
            }
            let products:[Products] = try await APIClient.sendRequest(endPoint: .products)
            
            // save to swiftData
            products.forEach{modelContext?.insert($0)}
            try? modelContext?.save()
            fetchProductsFromSwiftData()
        } catch {
            viewState = .failure(error)
        }
    }
    
    func fetchProductsFromSwiftData() {
        let fetchRequest = FetchDescriptor<Products>(
            predicate: #Predicate { $0.productName != "" },
            sortBy: [SortDescriptor(\.productName)]
        )
        products = try! modelContext?.fetch(fetchRequest)
        
        guard let products = products, !products.isEmpty else {
            viewState = .empty
            return
        }
        
        self.products = products.sorted { $0.favorite && !$1.favorite }
        viewState = .success(self.products!)
    }

    // while searching update data
    func updateProducts(searchText: String) {
        if !searchText.isEmpty{
            let filtedProducts = products?.compactMap { item in
                let titleQuery = item.productName?.range(of: searchText,options: .caseInsensitive) != nil
                return titleQuery ? item : nil
            }
            guard let products = filtedProducts, !products.isEmpty else {
                viewState = .empty
                return
            }
            viewState = .success(products)
        } else {
            guard let products = products, !products.isEmpty else {
                viewState = .empty
                return
            }
            viewState = .success(products)
        }
    }
    
    func getProductTypes() -> [String] {
        return Array(Set(products?.compactMap { $0.productType } ?? []))
    }
    
    func updateFavoriteStatus() {
        do {
            try modelContext?.save()
        } catch {
            print("Error saving favorite status: \(error)")
        }
        
        fetchProductsFromSwiftData()
    }
}

extension ProductsViewModel {
    func observeNetworkChanges() {
        NetworkMonitor.shared.publisher()
            .sink { isConnected in
                print("Network connected: \(isConnected)")
                if isConnected {
                    Task {
                        await self.syncUnsyncedRequests()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func syncUnsyncedRequests() async {
        let fetchRequest = FetchDescriptor<ProductRequestEntity>(
            predicate: #Predicate { $0.productName != "" }
        )
        
        do {
            // Fetch all unsynced requests
            let unsyncedRequests: [ProductRequestEntity] = try modelContext?.fetch(fetchRequest) ?? []
            
            // Check if there are unsynced requests
            guard !unsyncedRequests.isEmpty else {
                print("No unsynced requests to process.")
                return
            }
            
            for requestEntity in unsyncedRequests {
                do {
                    // Create the API request object
                    let request = ProductRequest(
                        productName: requestEntity.productName,
                        productType: requestEntity.productType,
                        price: requestEntity.price,
                        tax: requestEntity.tax
                    )
                    
                    // Send the API request
                    let response: AddProductResponse? = try await APIClient.sendRequest(endPoint: .addProduct(request))
                    
                    // If successful, delete the entity from SwiftData
                    modelContext?.delete(requestEntity)
                    try modelContext?.save()
                    print("Successfully synced and deleted request: \(requestEntity.productName)")
                } catch {
                    print("Failed to sync request for product: \(requestEntity.productName). Error: \(error)")
                }
            }
        } catch {
            print("Failed to fetch unsynced requests: \(error)")
        }
    }
}
