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

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(service: String, account: String, data: String) {
        let data = Data(data.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
