//
//  AddEmailView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

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
                Section(header: Text("Email")) {
                    TextField("Enter email", text: $emailValue)
                        .autocapitalization(.none)
                }

                Section(header: Text("Destination")) {
                    Picker("Select Destination", selection: $selectedDestination) {
                        ForEach(destinationAddressesViewModel.destinationAddresses, id: \.self) { address in
                            Text(address.email).tag(address as DestinationAddress?)
                        }
                    }
                }
            }
            .navigationBarTitle("Add Email", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }, trailing:
                Button("Save") {
                    saveEmail()
                    presentationMode.wrappedValue.dismiss()
                }
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
