//
//  DestinationAddressesViewModel.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.

import SwiftUI

class DestinationAddressesViewModel: ObservableObject {
    @Published var destinationAddresses: [DestinationAddress] = []
    @Published var showAddDestinationAddressView: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let cloudflareService = CloudflareService()
    private var isFetching: Bool = false
    private var lastFetchTime: Date?
    private let fetchTimeout: TimeInterval = 300 // Configurable timeout in seconds (e.g., 5 minutes)

    func fetchDestinationAddresses() {
        guard !isFetching else { return }

        if let lastFetch = lastFetchTime, Date().timeIntervalSince(lastFetch) < fetchTimeout {
            return
        }

        isFetching = true
        isLoading = true
        errorMessage = nil

        cloudflareService.listDestinationAddresses { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetching = false
                self.isLoading = false
                switch result {
                case .success(let addresses):
                    self.destinationAddresses = addresses
                    self.lastFetchTime = Date()
                case .failure(let error):
                    self.errorMessage = "Failed to fetch destination addresses: \(error.localizedDescription)"
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
                    self.lastFetchTime = Date()
                case .failure(let error):
                    self.errorMessage = "Failed to add destination address: \(error.localizedDescription)"
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
                    self.lastFetchTime = Date()
                case .failure(let error):
                    self.errorMessage = "Failed to delete destination address: \(error.localizedDescription)"
                }
            }
        }
    }

    func dismissError() {
        errorMessage = nil
    }
}
