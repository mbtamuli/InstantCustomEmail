//
//  InstantCustomEmailApp.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 14/11/24.
//

import SwiftUI

@main
struct InstantCustomEmailApp: App {
    @StateObject private var routingRulesViewModel = RoutingRulesViewModel()
    @StateObject private var destinationAddressesViewModel = DestinationAddressesViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(routingRulesViewModel)
                .environmentObject(destinationAddressesViewModel)
        }
    }
}
