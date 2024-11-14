//
//  AddAliasView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 14/11/24.
//

import SwiftUI
import SwiftData

struct AddAliasView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss  // To dismiss the view after adding the alias

    @State private var customAddress: String = ""
    @State private var destinationEmail: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom Address")) {
                    TextField("e.g., mctrl@user.com", text: $customAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section(header: Text("Destination Email")) {
                    TextField("e.g., user+finance@gmail.com", text: $destinationEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Alias")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addAlias()
                    }
                    .disabled(customAddress.isEmpty || destinationEmail.isEmpty)  // Disable if fields are empty
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addAlias() {
        // Find or create the destination email entry
        let destination = findOrCreateDestination(email: destinationEmail)

        // Create the new alias and associate it with the destination
        let alias = Alias(customAddress: customAddress, destination: destination)
        context.insert(alias)

        // Save changes
        try? context.save()

        // Dismiss the view
        dismiss()
    }

    private func findOrCreateDestination(email: String) -> Destination {
        let fetchDescriptor = FetchDescriptor<Destination>(predicate: #Predicate { $0.email == email })

        // Attempt to fetch the destination with the given email
        if let existingDestination = try? context.fetch(fetchDescriptor).first {
            return existingDestination
        } else {
            // If not found, create a new Destination
            let newDestination = Destination(email: email)
            context.insert(newDestination)
            return newDestination
        }
    }
}
