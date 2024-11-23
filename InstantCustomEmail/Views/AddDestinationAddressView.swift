import SwiftUI

struct AddDestinationAddressView: View {
    @ObservedObject var viewModel: DestinationAddressesViewModel
    @State private var email: String = ""  // Updated for email field

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email Address")) {
                    TextField(
                        "e.g., user@example.com",
                        text: $email
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Destination Address")
            .navigationBarItems(
                leading: Button("Cancel") {
                    viewModel.showAddDestinationAddressView = false
                },
                trailing: Button("Save") {
                    viewModel.addDestinationAddress(email: email)  // Using addDestinationAddress function
                    viewModel.showAddDestinationAddressView = false
                }
            )
        }
    }
}
