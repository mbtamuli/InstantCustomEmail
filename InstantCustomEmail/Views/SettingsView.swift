import SwiftUI

struct SettingsView: View {
    private let cloudflareService = CloudflareService()
    @State private var verificationMessage: String = ""
    @State private var accountId: String = UserDefaults.standard.string(forKey: Constants.cloudflareAccountIdKey) ?? ""
    @State private var apiToken: String = KeychainHelper.shared.read(service: "CloudflareService", account: "apiToken") ?? ""
    @State private var showAlert: Bool = false  // Controls when the alert is shown
    @State private var alertTitle: String = "" // Title for the alert

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cloudflare Account ID")) {
                    TextField("Account ID", text: $accountId)
                }
                Section(header: Text("Cloudflare API Token")) {
                    SecureField("API Token", text: $apiToken)
                }
                VStack {
                    Button(action: {
                        cloudflareService.verifyToken { result in
                            switch result {
                            case .success(let message):
                                alertTitle = "Success"
                                verificationMessage = message
                                showAlert = true
                            case .failure(let error):
                                alertTitle = "Error"
                                verificationMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Verify API Token")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Save") {
                UserDefaults.standard.set(accountId, forKey: Constants.cloudflareAccountIdKey)
                KeychainHelper.shared.save(service: "CloudflareService", account: "apiToken", data: apiToken)
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
