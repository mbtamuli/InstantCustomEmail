//
//  ContentView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 14/11/24.
//
import SwiftUI
import SwiftData

struct AliasListView: View {
    @Query(sort: \Alias.customAddress) private var aliases: [Alias]
    @Environment(\.modelContext) private var context
    @State private var showingAddAliasView = false

    var body: some View {
        NavigationView {
            List {
                // Group aliases by the domain of the custom address
                ForEach(groupedAliases.keys.sorted(), id: \.self) { domain in
                    Section(header: Text(domain)) {
                        ForEach(groupedAliases[domain] ?? []) { alias in
                            VStack(alignment: .leading) {
                                Text(alias.customAddress).font(.headline)
                                Text("→ \(alias.destination.email)").font(.subheadline)
                            }
                        }
                        .onDelete { indexSet in
                            deleteAliases(at: indexSet, in: domain)
                        }
                    }
                }
            }
            .navigationTitle("Email Aliases")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Alias") {
                        showingAddAliasView = true
                    }
                }
            }
            .sheet(isPresented: $showingAddAliasView) {
                AddAliasView()
            }
        }
    }

    // Helper to group aliases by domain
    private var groupedAliases: [String: [Alias]] {
        Dictionary(grouping: aliases) { alias in
            extractDomain(from: alias.customAddress)
        }
    }

    // Helper to extract domain from an email address
    private func extractDomain(from email: String) -> String {
        let components = email.split(separator: "@")
        return components.count > 1 ? String(components[1]) : email
    }

    // Delete aliases in a specific domain
    private func deleteAliases(at offsets: IndexSet, in domain: String) {
        if let aliasesInDomain = groupedAliases[domain] {
            offsets.map { aliasesInDomain[$0] }.forEach(context.delete)
            try? context.save()
        }
    }
}

#Preview {
    AliasListView()
        .modelContainer(sampleModelContainer())
}
