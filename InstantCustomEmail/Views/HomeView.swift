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
    @State private var showSearchResults = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top)

                // Heading
                Text("Targets")
                    .font(.title)
                    .padding(.top)

                // Destination Addresses List
                List {
                    ForEach(destinationAddressesViewModel.destinationAddresses, id: \.id) { address in
                        DestinationListItemView(
                            address: address,
                            routingRulesCount: routingRulesCount(for: address)
                        )
                        .background(
                            NavigationLink(
                                destination: DestinationDetailView(destinationAddress: address)
                            ) {
                                EmptyView()
                            }
                            .opacity(0)
                        )
                    }
                    .onDelete(perform: deleteDestination)
                }
                .listStyle(PlainListStyle())

                Spacer()

                // Bottom Buttons
                HStack {
                    Button(action: {
                        showAddEmailView = true
                    }) {
                        Label("Add Email", systemImage: "plus")
                    }
                    Spacer()
                    Button(action: {
                        showAddDestinationView = true
                    }) {
                        Label("Add Target", systemImage: "plus")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    showSettingsView = true
                }) {
                    Image(systemName: "ellipsis.circle")
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
            .sheet(isPresented: $showSearchResults) {
                SearchResultsView(showSearchResults: $showSearchResults)
                    .environmentObject(routingRulesViewModel)
                    .environmentObject(destinationAddressesViewModel)
            }
            .onAppear {
                destinationAddressesViewModel.fetchDestinationAddresses()
                routingRulesViewModel.loadRoutingRules()
            }
        }
    }

    func deleteDestination(at offsets: IndexSet) {
        for index in offsets {
            let address = destinationAddressesViewModel.destinationAddresses[index]
            destinationAddressesViewModel.deleteDestinationAddress(identifier: address.id)
        }
    }

    func routingRulesCount(for address: DestinationAddress) -> Int {
        routingRulesViewModel.routingRules.filter { rule in
            rule.actions.contains { action in
                action.value?.contains(address.email) == true
            }
        }.count
    }
}
