//
//  Item.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 14/11/24.
//

import SwiftData
import Foundation

@Model
final class Destination {
    @Attribute(.unique) var email: String  // The destination email (e.g., "user+finance@gmail.com")
    var aliases: [Alias] = []  // Relationship to Alias objects

    init(email: String) {
        self.email = email
    }
}

@Model
final class Alias {
    @Attribute(.unique) var customAddress: String  // The custom address (e.g., "hdfcbank@user.com")
    var destination: Destination  // Relationship to a Destination

    init(customAddress: String, destination: Destination) {
        self.customAddress = customAddress
        self.destination = destination
    }
}

class EmailRouteManager {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // Add an alias and associate it with a destination
    func addAlias(customAddress: String, destinationEmail: String) throws {
        // Check if the destination exists
        let fetchDescriptor = FetchDescriptor<Destination>(predicate: #Predicate { $0.email == destinationEmail })
        let existingDestinations = try context.fetch(fetchDescriptor)

        if let destination = existingDestinations.first {
            let alias = Alias(customAddress: customAddress, destination: destination)
            context.insert(alias)
        } else {
            // Create a new destination and associate it with the alias
            let newDestination = Destination(email: destinationEmail)
            let alias = Alias(customAddress: customAddress, destination: newDestination)
            context.insert(newDestination)
            context.insert(alias)
        }

        try context.save()
    }

    // Fetch all aliases
    func fetchAliases() throws -> [Alias] {
        let fetchDescriptor = FetchDescriptor<Alias>()  // Fetches all aliases
        return try context.fetch(fetchDescriptor)
    }

    // Delete an alias
    func deleteAlias(_ alias: Alias) throws {
        context.delete(alias)
        try context.save()
    }
}

// Helper function to create a sample ModelContainer with pre-seeded data
@MainActor func sampleModelContainer() -> ModelContainer {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)  // In-memory storage for preview
    let container = try! ModelContainer(
        for: Destination.self,
        Alias.self,
        configurations: configuration)

    let context = container.mainContext

    // Create sample destinations
    let financeDestination = Destination(email: "user+finance@gmail.com")
    let entertainmentDestination = Destination(email: "user+entertainment@gmail.com")
    let contactDestination = Destination(email: "user+contact@gmail.com")

    // Add sample aliases for each destination
    let aliases = [
        Alias(customAddress: "mctrl@user.com", destination: financeDestination),
        Alias(customAddress: "tneu@user.com", destination: financeDestination),
        Alias(customAddress: "crunchyroll@user.com", destination: entertainmentDestination),
        Alias(customAddress: "rsg@user.com", destination: entertainmentDestination),
        Alias(customAddress: "contact@user2.com", destination: contactDestination)
    ]

    // Insert data into the context
    context.insert(financeDestination)
    context.insert(entertainmentDestination)
    context.insert(contactDestination)
    aliases.forEach { context.insert($0) }

    try? context.save()  // Save data

    return container
}
