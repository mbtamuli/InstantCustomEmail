//
//  DestinationDetailView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct DestinationDetailView: View {
    @EnvironmentObject var routingRulesViewModel: RoutingRulesViewModel
    let destinationAddress: DestinationAddress

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label(destinationAddress.email, systemImage: "target")
                    .font(.headline)
                Spacer()
                if destinationAddress.verified != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .padding()

            List {
                ForEach(rulesForDestination) { rule in
                    if let matcherValue = rule.matchers.first(where: { $0.field == "to" })?.value {
                        Label(matcherValue, systemImage: "arrow.uturn.right")
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteRoutingRule(rule)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }

    func deleteRoutingRule(_ rule: RoutingRule) {
        routingRulesViewModel.deleteRoutingRule(ruleId: rule.id)
    }

    var rulesForDestination: [RoutingRule] {
        routingRulesViewModel.routingRules.filter { rule in
            rule.actions.contains { action in
                action.value?.contains(destinationAddress.email) == true
            }
        }
    }
}
