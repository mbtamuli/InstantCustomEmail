//
//  RoutingRulesViewModel.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

import Foundation
import SwiftUI

class RoutingRulesViewModel: ObservableObject {
    @Published var routingRules: [RoutingRule] = [] {
        didSet {
            groupRoutingRulesByDestination()
        }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var groupedRoutingRules: [String: [RoutingRule]] = [:]

    var hasLoaded: Bool = false  // Changed access level to make it accessible

    private var isFetching: Bool = false

    func loadRoutingRules() {
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

        print("Fetching routing rules...")

        CloudflareService().listRoutingRules { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isFetching = false
                self.isLoading = false
                switch result {
                case .success(let rules):
                    self.routingRules = rules
                    self.hasLoaded = true
                    print("Fetched routing rules successfully")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    print("Error fetching routing rules: \(error)")
                }
            }
        }
    }

    private func groupRoutingRulesByDestination() {
        let grouped = Dictionary(grouping: routingRules) { (rule) -> String in
            if let destination = rule.actions.first?.value?.first {
                return destination
            } else {
                return "Unknown"
            }
        }
        self.groupedRoutingRules = grouped
    }
}
