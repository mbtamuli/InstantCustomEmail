//
//  DestinationSelectionView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct DestinationSelectionView: View {
    @EnvironmentObject var destinationAddressesViewModel: DestinationAddressesViewModel
    @Binding var selectedDestination: DestinationAddress?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(destinationAddressesViewModel.destinationAddresses) { address in
            Button(action: {
                selectedDestination = address
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text(address.email)
                        .foregroundColor(.primary)
                        .lineLimit(nil) // Allows full email to be visible
                    Spacer()
                    if selectedDestination == address {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationBarTitle("Select Destination", displayMode: .inline)
        .onAppear {
            destinationAddressesViewModel.fetchDestinationAddresses()
        }
    }
}
