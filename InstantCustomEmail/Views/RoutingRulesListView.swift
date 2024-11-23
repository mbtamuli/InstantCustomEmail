//
//  RoutingRulesListView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

import SwiftUI

struct RoutingRulesView: View {
    @EnvironmentObject var viewModel: RoutingRulesViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(viewModel.groupedRoutingRules.keys.sorted(), id: \.self) { destination in
                            NavigationLink(
                                destination: RoutingRulesDetailView(
                                    destination: destination,
                                    rules: viewModel.groupedRoutingRules[destination] ?? []
                                )
                            ) {
                                Text(destination)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Routing Rules")
            .onAppear {
                if !viewModel.hasLoaded {
                    viewModel.loadRoutingRules()
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    primaryButton: .default(Text("Retry")) {
                        viewModel.loadRoutingRules()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

