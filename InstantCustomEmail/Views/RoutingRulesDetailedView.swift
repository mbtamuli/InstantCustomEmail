//
//  RoutingRulesDetailedView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

import SwiftUI

struct RoutingRulesDetailView: View {
    let destination: String
    let rules: [RoutingRule]

    var body: some View {
        List {
            // Display the full destination address at the top
            Section(header: Text("Destination").font(.headline)) {
                Text(destination)
                    .font(.body)
                    .lineLimit(nil) // Allow the text to wrap and display fully
                    .multilineTextAlignment(.leading)
            }

            // Display the routing rules
            Section(header: Text("Routing Rules").font(.headline)) {
                ForEach(rules) { rule in
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(rule.matchers, id: \.value) { matcher in
                            if matcher.field == "to" {
                                Text(matcher.value ?? "Unknown")
                                    .font(.headline)
                                    .lineLimit(nil)
                            }
                        }
                        if let ruleName = rule.name, !ruleName.isEmpty {
                            Text(ruleName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Routing Rules")
        .navigationBarTitleDisplayMode(.inline)
    }
}
