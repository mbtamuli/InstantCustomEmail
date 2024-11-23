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
            ContentView()
                .environmentObject(routingRulesViewModel)
                .environmentObject(destinationAddressesViewModel)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            DestinationAddressesView()
                .tabItem {
                    Label("Destination Addresses", systemImage: "envelope")
                }

            RoutingRulesView()
                .tabItem {
                    Label("Routing Rules", systemImage: "list.dash")
                }
        }
    }
}
