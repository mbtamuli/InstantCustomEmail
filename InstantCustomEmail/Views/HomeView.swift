//
//  HomeView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var routingRulesViewModel: RoutingRulesViewModel
    @EnvironmentObject var destinationAddressesViewModel: DestinationAddressesViewModel

    @State private var showAddEmailView = false
    @State private var showAddDestinationView = false
    @State private var showSettingsView = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)

                // Destination Addresses List
                Text("My Emails")
                    .font(.headline)
                    .padding(.top)

                List {
                    ForEach(filteredDestinations, id: \.id) { address in
                        NavigationLink(destination: DestinationDetailView(destination: address.email)) {
                            Text(address.email)
                        }
                    }
                }
                .listStyle(PlainListStyle())

                Spacer()

                // Bottom Buttons
                HStack {
                    Button(action: {
                        showAddEmailView = true
                    }) {
                        Label("Add Email", systemImage: "plus.circle.fill")
                    }

                    Spacer()

                    Button(action: {
                        showAddDestinationView = true
                    }) {
                        Text("Add Target")
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarItems(trailing:
                Button(action: {
                    showSettingsView = true
                }) {
                    Image(systemName: "gear")
                }
            )
            .sheet(isPresented: $showAddEmailView) {
                AddEmailView()
                    .environmentObject(routingRulesViewModel)
                    .environmentObject(destinationAddressesViewModel)
            }
            .sheet(isPresented: $showAddDestinationView) {
                AddDestinationView()
                    .environmentObject(destinationAddressesViewModel)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .onAppear {
                destinationAddressesViewModel.fetchDestinationAddresses()
                routingRulesViewModel.loadRoutingRules()
            }
        }
    }

    var filteredDestinations: [DestinationAddress] {
        if searchText.isEmpty {
            return destinationAddressesViewModel.destinationAddresses
        } else {
            return destinationAddressesViewModel.destinationAddresses.filter { $0.email.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
