//
//  DestinationAddressesViewModel.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

import SwiftUI

class DestinationAddressesViewModel: ObservableObject {
    @Published var destinationAddresses: [DestinationAddress] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false

    var hasLoaded: Bool = false

    private var isFetching: Bool = false
    private let cloudflareService = CloudflareService()

    func fetchDestinationAddresses() {
        guard !isFetching else {
            print("Skipping fetch: already fetching")
            return
        }

        if hasLoaded {
            print("Skipping fetch: already loaded")
            return
        }

        isFetching = true
        isLoading = true
        errorMessage = nil

        print("Fetching destination addresses...")

        cloudflareService.listDestinationAddresses { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetching = false
                self.isLoading = false
                switch result {
                case .success(let addresses):
                    self.destinationAddresses = addresses
                    self.hasLoaded = true
                    print("Fetched destination addresses successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Error fetching destination addresses: \(error)")
                }
            }
        }
    }

    func addDestinationAddress(email: String) {
        guard !email.isEmpty else {
            errorMessage = "Email address is required."
            return
        }
        isLoading = true
        cloudflareService.createDestinationAddress(email: email) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let address):
                    self.destinationAddresses.append(address)
                    print("Added destination address successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Error adding destination address: \(error)")
                }
            }
        }
    }

    func deleteDestinationAddress(identifier: String) {
        guard !identifier.isEmpty else {
            errorMessage = "Invalid destination address identifier."
            return
        }
        isLoading = true
        cloudflareService.deleteDestinationAddress(identifier: identifier) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success:
                    self.destinationAddresses.removeAll { $0.id == identifier }
                    print("Deleted destination address successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Error deleting destination address: \(error)")
                }
            }
        }
    }
}
