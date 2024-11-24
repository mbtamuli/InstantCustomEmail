//
//  RoutingRuleDetailView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

import SwiftUI

struct RoutingRuleDetailView: View {
    let rule: RoutingRule

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(rule.name ?? "Unnamed Rule")
                .font(.title)
                .padding(.bottom)

            Text("Enabled: \(rule.enabled ? "Yes" : "No")")
                .font(.subheadline)

            Text("Priority: \(rule.priority)")
                .font(.subheadline)

            Divider()
                .padding(.vertical)

            Text("Matchers")
                .font(.headline)

            ForEach(rule.matchers, id: \.value) { matcher in
                VStack(alignment: .leading) {
                    Text("Type: \(matcher.type ?? "Unknown")")
                    Text("Field: \(matcher.field ?? "Unknown")")
                    Text("Value: \(matcher.value ?? "Unknown")")
                }
                .padding(.bottom, 5)
            }

            Divider()
                .padding(.vertical)

            Text("Actions")
                .font(.headline)

            ForEach(rule.actions, id: \.type) { action in
                VStack(alignment: .leading) {
                    Text("Type: \(action.type)")
                    if let values = action.value {
                        Text("Value: \(values.joined(separator: ", "))")
                    }
                }
                .padding(.bottom, 5)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Rule Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
