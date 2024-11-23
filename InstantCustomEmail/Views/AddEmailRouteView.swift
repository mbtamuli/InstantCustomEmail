import SwiftUI

struct AddEmailRouteView: View {
    @ObservedObject var viewModel: EmailRoutesViewModel
    @State private var customAddress: String = ""
    @State private var destinationAddress: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom Address")) {
                    TextField(
                        "e.g., mctrl@user.com",
                        text: $customAddress
                    )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section(header: Text("Destination Email")) {
                    TextField(
                        "e.g., user+finance@gmail.com",
                        text: $destinationAddress
                    )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Email Route")
            .navigationBarItems(leading: Button("Cancel") {
                viewModel.showAddEmailRouteView = false
            }, trailing: Button("Save") {
                viewModel.addEmailRoute(customAddress: customAddress, destinationAddress: destinationAddress)
                viewModel.showAddEmailRouteView = false
            })
        }
    }
}
