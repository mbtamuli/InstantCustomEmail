//
//  DestinationDetailView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct DestinationDetailView: View {
    let destinationAddress: DestinationAddress
    @EnvironmentObject var routingRulesViewModel: RoutingRulesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // Display destination email details
            Text(destinationAddress.email)
                .font(.largeTitle)
                .padding(.bottom)

            Text("Created: \(formattedDate(destinationAddress.created))")
                .font(.subheadline)
            Text("Modified: \(formattedDate(destinationAddress.modified))")
                .font(.subheadline)
            if let verified = destinationAddress.verified {
                Text("Verified: \(formattedDate(verified))")
                    .font(.subheadline)
            } else {
                Text("Not Verified")
                    .font(.subheadline)
            }

            Divider()
                .padding(.vertical)

            // Display associated routing rules
            if rulesForDestination.isEmpty {
                Text("No routing rules for this destination.")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(rulesForDestination) { rule in
                        NavigationLink(destination: RoutingRuleDetailView(rule: rule)) {
                            VStack(alignment: .leading) {
                                Text(rule.name ?? "Unnamed Rule")
                                    .font(.headline)
                                ForEach(rule.matchers, id: \.value) { matcher in
                                    if matcher.field == "to" {
                                        Text("Matches: \(matcher.value ?? "Unknown")")
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Destination Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Helper function to format dates
    func formattedDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }

    // Fetch routing rules associated with the destination email
    var rulesForDestination: [RoutingRule] {
        routingRulesViewModel.routingRules.filter { rule in
            rule.actions.contains { action in
                action.value?.contains(destinationAddress.email) == true
            }
        }
    }
}
