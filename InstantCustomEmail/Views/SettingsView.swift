import SwiftUI

struct SettingsView: View {
    private let cloudflareService = CloudflareService()

    @State private var verificationMessage: String = ""
    @State private var accountId: String = UserDefaults.standard.string(forKey: Constants.cloudflareAccountIdKey) ?? ""
    @State private var apiToken: String = KeychainHelper.shared.read(service: "CloudflareService", account: "apiToken") ?? ""
    @State private var zoneId: String = UserDefaults.standard.string(forKey: "CloudflareZoneIdKey") ?? ""
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""

    var body: some View {
        NavigationView {
            Form {
                // Cloudflare Account ID Section
                Section(header: Text("Cloudflare Account ID")) {
                    TextField("Account ID", text: $accountId)
                        .autocapitalization(.none)
                }

                // Cloudflare API Token Section
                Section(header: Text("Cloudflare API Token")) {
                    SecureField("API Token", text: $apiToken)
                        .autocapitalization(.none)
                }

                // Cloudflare Zone ID Section
                Section(header: Text("Cloudflare Zone ID")) {
                    TextField("Enter Cloudflare Zone ID", text: $zoneId)
                        .autocapitalization(.none)
                        .keyboardType(.default)
                }

                // Verify Token Button Section
                VStack {
                    Button(action: {
                        KeychainHelper.shared.save(service: "CloudflareService", account: "apiToken", data: apiToken)
                        cloudflareService.verifyToken { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let verifyResponse):
                                    alertTitle = "Success"
                                    if let message = verifyResponse.messages.first?.message {
                                        verificationMessage = message
                                    } else {
                                        verificationMessage = "API Token is valid."
                                    }
                                    showAlert = true
                                case .failure(let error):
                                    alertTitle = "Error"
                                    verificationMessage = error.localizedDescription
                                    showAlert = true
                                }
                            }
                        }
                    }) {
                        Text("Verify API Token")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Save") {
                // Save settings to UserDefaults and Keychain
                UserDefaults.standard.set(accountId, forKey: Constants.cloudflareAccountIdKey)
                KeychainHelper.shared.save(service: "CloudflareService", account: "apiToken", data: apiToken)
                UserDefaults.standard.set(zoneId, forKey: "CloudflareZoneIdKey")
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(verificationMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
