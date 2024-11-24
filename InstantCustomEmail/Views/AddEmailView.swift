//
//  AddEmailView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

// AddEmailView.swift

import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var routingRulesViewModel: RoutingRulesViewModel
    @EnvironmentObject var destinationAddressesViewModel: DestinationAddressesViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var emailValue: String = ""
    @State private var selectedDestination: DestinationAddress?

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "arrow.uturn.right")
                        TextField("Email", text: $emailValue)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                }


                Section {
                    NavigationLink(
                        destination: DestinationSelectionView(selectedDestination: $selectedDestination)
                            .environmentObject(destinationAddressesViewModel)
                    ) {
                        VStack(alignment: .leading, spacing: 5) {
                            Label {
                                Text("Destination")
                            } icon: {
                                Image(systemName: "target")
                                    .foregroundColor(.primary)
                            }

                            if let destination = selectedDestination {
                                Text(destination.email)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Select a destination")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8) // Adds space above and below the NavigationLink
                    }
                }
            }
            .navigationBarTitle("Add Email", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveEmail()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(emailValue.isEmpty || selectedDestination == nil) // Disable Save if fields are empty
            )
        }
    }

    func saveEmail() {
        guard let destinationEmail = selectedDestination?.email, !emailValue.isEmpty else {
            return
        }

        let matcher = RoutingRule.Matcher(type: "literal", field: "to", value: emailValue)
        let action = RoutingRule.Action(type: "forward", value: [destinationEmail])
        let newRule = RoutingRule(
            id: UUID().uuidString,
            tag: nil,
            name: "Rule for \(emailValue)",
            matchers: [matcher],
            actions: [action],
            enabled: true,
            priority: 0
        )

        routingRulesViewModel.createRoutingRule(rule: newRule)
    }
}
