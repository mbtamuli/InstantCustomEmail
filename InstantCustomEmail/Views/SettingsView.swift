import SwiftUI
import Security

struct SettingsView: View {
    @State private var accountId: String = UserDefaults.standard.string(forKey: cloudflareAccountIdKey) ?? ""
    @State private var apiToken: String = KeychainHelper.shared.read(service: "CloudflareService", account: "apiToken") ?? ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cloudflare Account ID")) {
                    TextField("Account ID", text: $accountId)
                }
                Section(header: Text("Cloudflare API Token")) {
                    SecureField("API Token", text: $apiToken)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Save") {
                UserDefaults.standard.set(accountId, forKey: cloudflareAccountIdKey)
                KeychainHelper.shared.save(service: "CloudflareService", account: "apiToken", data: apiToken)
            })
        }
    }
}
