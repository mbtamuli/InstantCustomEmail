import SwiftUI

class EmailAliasViewModel: ObservableObject {
    @Published var emailAliases: [EmailAlias] = []

    private let cloudflareService = CloudflareService()

    func fetchEmailAliases() {
        cloudflareService.getEmailRoutes { result in
            switch result {
            case .success(let aliases):
                DispatchQueue.main.async {
                    self.emailAliases = aliases
                }
            case .failure(let error):
                print("Failed to fetch email aliases: \(error)")
            }
        }
    }

    func addEmailAlias(alias: String, destination: String) {
        cloudflareService.createEmailRoute(customAddress: alias, destinationAddress: destination) { result in
            switch result {
            case .success(let alias):
                DispatchQueue.main.async {
                    self.emailAliases.append(alias)
                }
            case .failure(let error):
                print("Failed to add email alias: \(error)")
            }
        }
    }

    func deleteEmailAlias(aliasIdentifier: String) {
        cloudflareService.deleteEmailRoute(destinationAddressIdentifier: aliasIdentifier) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.emailAliases.removeAll { $0.id == aliasIdentifier }
                }
            case .failure(let error):
                print("Failed to delete email alias: \(error)")
            }
        }
    }
}
