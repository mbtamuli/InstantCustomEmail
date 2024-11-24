//
//  SearchResultsView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct SearchResultsView: View {
    @Binding var showSearchResults: Bool
    @EnvironmentObject var routingRulesViewModel: RoutingRulesViewModel
    @EnvironmentObject var destinationAddressesViewModel: DestinationAddressesViewModel

    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top)

                // Search Results List
                List {
                    ForEach(filteredRoutingRules) { rule in
                        ForEach(rule.matchers, id: \.value) { matcher in
                            if matcher.field == "to" && matcher.value?.localizedCaseInsensitiveContains(searchText) == true {
                                if let destinationEmail = rule.actions.first?.value?.first,
                                   let destinationAddress = destinationAddressesViewModel.destinationAddresses.first(where: { $0.email == destinationEmail }) {
                                    NavigationLink(destination: DestinationDetailView(destinationAddress: destinationAddress)) {
                                        VStack(alignment: .leading) {
                                            Text(matcher.value ?? "Unknown")
                                            Text("Destination: \(destinationEmail)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                } else {
                                    // If destination address is not found, navigate to rule details
                                    NavigationLink(destination: RoutingRuleDetailView(rule: rule)) {
                                        Text(matcher.value ?? "Unknown")
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Search", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    showSearchResults = false
                }) {
                    Text("Cancel")
                }
            )
        }
    }

    var filteredRoutingRules: [RoutingRule] {
        if searchText.isEmpty {
            return []
        } else {
            return routingRulesViewModel.routingRules.filter { rule in
                rule.matchers.contains(where: { matcher in
                    matcher.field == "to" && (matcher.value?.localizedCaseInsensitiveContains(searchText) == true)
                })
            }
        }
    }
}
