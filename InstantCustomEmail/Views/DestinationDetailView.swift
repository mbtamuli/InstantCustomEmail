//
//  DestinationDetailView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct DestinationDetailView: View {
    let destination: String
    @EnvironmentObject var routingRulesViewModel: RoutingRulesViewModel

    var body: some View {
        List {
            ForEach(rulesForDestination) { rule in
                ForEach(rule.matchers, id: \.value) { matcher in
                    if matcher.field == "to" {
                        Text(matcher.value ?? "Unknown")
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle(destination)
    }

    var rulesForDestination: [RoutingRule] {
        routingRulesViewModel.routingRules.filter { rule in
            rule.actions.contains(where: { $0.value?.contains(destination) == true })
        }
    }
}
