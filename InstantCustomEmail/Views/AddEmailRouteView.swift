import SwiftUI

struct AddEmailRouteView: View {
    @ObservedObject var viewModel: EmailRoutesViewModel
    @State private var customAddress: String = ""
    @State private var destinationAddress: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Custom Address")) {
                    TextField("Custom Address", text: $customAddress)
                }
                Section(header: Text("Destination Address")) {
                    TextField("Destination Address", text: $destinationAddress)
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
