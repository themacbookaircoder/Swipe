//
//  ContentNotavailableView.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI

enum ContentUnavailableType {
    case connectionIssue
    case noDataAvailable
    case noFavorites
    case errorOccurred(String, retryCallback: () -> Void)
    
    var title: String {
        switch self {
        case .connectionIssue:
            return "Connection issue"
        case .noDataAvailable:
            return "No Products available"
        case .noFavorites:
            return "No favorites"
        case .errorOccurred:
            return "An error occurred"
        }
    }
    
    var systemImage: String {
        switch self {
        case .connectionIssue:
            return "wifi.slash"
        case .noDataAvailable:
            return "newspaper"
        case .noFavorites:
            return "star.slash"
        case .errorOccurred:
            return "xmark.octagon"
        }
    }
    
    var description: String {
        switch self {
        case .connectionIssue:
            return "Check your internet connection"
        case .noDataAvailable:
            return "No Products available at the moment."
        case .noFavorites:
            return "You haven't added any favorites yet."
        case .errorOccurred(let description, _):
            return description
        }
    }
    
    var retryCallback: (() -> Void)? {
        if case let .errorOccurred(_,retryCallback) = self {
            return retryCallback
        }
        return nil
    }
}

import SwiftUI

struct ContentNotavailableView: View {
    
    // MARK: - Properties
    let contentType: ContentUnavailableType
    
    // MARK: - Body
    var body: some View {
        VStack {
            Image(systemName: contentType.systemImage)
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text(contentType.title)
                .textStyle(color: .primary, font: .headline, weight: .semibold)
            Text(contentType.description)
                .textStyle(color: .secondary, font: .subheadline, weight: .semibold)
            if let retryCallback = contentType.retryCallback {
                Button("Retry", action: retryCallback)
                    .buttonStyle(.bordered)
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    ContentNotavailableView(contentType: .connectionIssue)
}
