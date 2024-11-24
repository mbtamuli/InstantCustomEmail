//
//  AddDestinationView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct AddDestinationView: View {
    @EnvironmentObject var destinationAddressesViewModel: DestinationAddressesViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Destination Email")) {
                    TextField("e.g., user@example.com", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationBarTitle("Add Target", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }, trailing:
                Button("Save") {
                    saveDestination()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    func saveDestination() {
        destinationAddressesViewModel.addDestinationAddress(email: email)
    }
}
