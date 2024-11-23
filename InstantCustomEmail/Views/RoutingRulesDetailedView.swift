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
        List(rules) { rule in
            VStack(alignment: .leading) {
                ForEach(rule.matchers, id: \.value) { matcher in
                    if matcher.field == "to" {
                        Text(matcher.value ?? "Unknown")
                            .font(.headline)
                    }
                }
                if let ruleName = rule.name, !ruleName.isEmpty {
                    Text(ruleName)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(destination)
    }
}
