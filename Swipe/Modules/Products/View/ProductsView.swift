//
//  ProductsView.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI
import SwiftData

struct ProductsView: View {
    
    // MARK: - Properties
    @Environment(\.modelContext) var modelContext
    @State private var viewModel = ProductsViewModel()
    private let columns:[GridItem] = Array(repeating: GridItem(spacing: 20), count: 2)
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 30){
                    SearchBar(searchText: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { oldValue, newValue in
                            viewModel.updateProducts(searchText: newValue)
                        }
                        .padding(.horizontal)
                    switch viewModel.viewState {
                    case .initial, .fetching:
                        Loader()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let products):
                        contentView(products: products)
                    case .failure(let error):
                        ContentNotavailableView(contentType: .errorOccurred(error.localizedDescription, retryCallback: {
                            Task {
                                await viewModel.getProducts()
                            }
                        }))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .empty:
                        ContentNotavailableView(contentType: .noDataAvailable)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        floatingButton
                    }
                    .padding([.bottom, .trailing])
                }
            }
            .navigationTitle("Products")
            .refreshable {
                await viewModel.getProducts()
            }
        }
        .task {
            viewModel.modelContext = modelContext
            viewModel.fetchProductsFromSwiftData()
            if (viewModel.products?.isEmpty ?? false){
                await viewModel.getProducts()
            }
        }
        .fullScreenCover(isPresented: $viewModel.addProduct) {
            let productTypes = viewModel.getProductTypes()
            if !productTypes.isEmpty {
                AddProductView(productType: productTypes) {
                    Task {
                        await viewModel.getProducts()
                    }
                }
            }
        }
    }
}

extension ProductsView {
    
    @ViewBuilder
    private func contentView(products:[Products]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products, id: \.self) { product in
                    ProductCell(product: product) {
                        viewModel.updateFavoriteStatus()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var floatingButton: some View {
        Button {
            viewModel.addProduct = true
        } label: {
            ZStack {
                Circle()
                    .fill(.thickMaterial)
                    .frame(width: 60, height: 60)
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    ProductsView()
}


struct ProductCell: View {
    
    // MARK: - Properties
    @ObservedObject var product: Products
    let completion:(() -> Void)
    
    // MARK: - Product
    var body: some View {
        ZStack(alignment: .bottom){
            AsyncImageView(urlString: product.image)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color.black.opacity(0.13), radius: 10, x: 0, y: 5)
                .overlay(alignment: .topTrailing) {
                    Button {
                        withAnimation {
                            product.favorite.toggle()
                            completion()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 35, height: 35)
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(product.favorite ? .pink : .white)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding(8)
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Name: \(product.productName ?? "--")")
                    .textStyle(color: .white, font: .headline, weight: .bold, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text("Type: \(product.productType ?? "--")")
                    .textStyle(color: .white,font: .subheadline, weight: .medium)
                Text("Price: \(product.price?.toString() ?? "--")")
                    .textStyle(color: .white,font: .caption, weight: .medium)
                Text("Tax: \(product.tax?.toString() ?? "--") %")
                    .textStyle(color: .white,font: .caption2, weight: .medium)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
    }
}
