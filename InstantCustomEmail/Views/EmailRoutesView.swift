import SwiftUI

struct EmailRoutesView: View {
    @ObservedObject var viewModel: EmailRoutesViewModel

    var body: some View {
        NavigationView {
            List(viewModel.emailRoutes) { route in
                VStack(alignment: .leading) {
                    Text(route.customAddress)
                        .font(.headline)
                    Text(route.destinationAddress)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Email Routes")
            .navigationBarItems(leading: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
            }, trailing: Button(action: {
                viewModel.showAddEmailRouteView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $viewModel.showAddEmailRouteView) {
                AddEmailRouteView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.fetchEmailRoutes()
        }
    }
}
