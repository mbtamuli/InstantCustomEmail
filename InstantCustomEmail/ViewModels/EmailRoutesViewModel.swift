import SwiftUI

class EmailRoutesViewModel: ObservableObject {
    @Published var emailRoutes: [EmailRoute] = []
    @Published var showAddEmailRouteView: Bool = false

    private let cloudflareService = CloudflareService()

    func fetchEmailRoutes() {
        cloudflareService.getEmailRoutes { result in
            switch result {
            case .success(let routes):
                DispatchQueue.main.async {
                    self.emailRoutes = routes
                }
            case .failure(let error):
                print("Failed to fetch email routes: \(error)")
            }
        }
    }

    func addEmailRoute(customAddress: String, destinationAddress: String) {
        cloudflareService.createEmailRoute(customAddress: customAddress, destinationAddress: destinationAddress) { result in
            switch result {
            case .success(let route):
                DispatchQueue.main.async {
                    self.emailRoutes.append(route)
                }
            case .failure(let error):
                print("Failed to add email route: \(error)")
            }
        }
    }

    func deleteEmailRoute(destinationAddressIdentifier: String) {
        cloudflareService.deleteEmailRoute(destinationAddressIdentifier: destinationAddressIdentifier) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.emailRoutes.removeAll { $0.id == destinationAddressIdentifier }
                }
            case .failure(let error):
                print("Failed to delete email route: \(error)")
            }
        }
    }
}
