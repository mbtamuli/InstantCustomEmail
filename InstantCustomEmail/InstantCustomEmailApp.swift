//
//  InstantCustomEmailApp.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 14/11/24.
//

import SwiftUI
import SwiftData

@main
struct InstantCustomEmailApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Destination.self,
            Alias.self
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
            AliasListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
