import SwiftUI

struct DestinationAddressesView: View {
    @EnvironmentObject var viewModel: DestinationAddressesViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.destinationAddresses) { address in
                        VStack(alignment: .leading) {
                            Text(address.email)
                                .font(.headline)
                            Text("Created: \(address.created)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Destination Addresses")
            .navigationBarItems(
                leading: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .accessibilityLabel("Settings")
                },
                trailing: Button(action: {
                    viewModel.showAddDestinationAddressView = true
                }) {
                    Image(systemName: "plus")
                        .accessibilityLabel("Add Destination Address")
                }
            )
            .sheet(isPresented: $viewModel.showAddDestinationAddressView) {
                AddDestinationAddressView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchDestinationAddresses()
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.dismissError() }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
