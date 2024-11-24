//
//  SwipeApp.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import SwiftUI
import SwiftData

@main
struct SwipeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Products.self,
            ProductRequestEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
