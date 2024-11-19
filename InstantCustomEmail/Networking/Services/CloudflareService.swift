import Foundation
import Moya

let cloudflareAccountIdKey = "CloudflareAccountId"

enum CloudflareAPI {
    case getEmailRoutes(accountId: String)
    case createEmailRoute(accountId: String, customAddress: String, destinationAddress: String)
    case deleteEmailRoute(accountId: String, destinationAddressIdentifier: String)
    case getEmailRoute(accountId: String, destinationAddressIdentifier: String)
}

extension CloudflareAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cloudflare.com/client/v4/accounts")!
    }

    var path: String {
        switch self {
        case .getEmailRoutes(let accountId):
            return "/\(accountId)/email/routing/addresses"
        case .createEmailRoute(let accountId, _, _):
            return "/\(accountId)/email/routing/addresses"
        case .deleteEmailRoute(let accountId, let destinationAddressIdentifier):
            return "/\(accountId)/email/routing/addresses/\(destinationAddressIdentifier)"
        case .getEmailRoute(let accountId, let destinationAddressIdentifier):
            return "/\(accountId)/email/routing/addresses/\(destinationAddressIdentifier)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getEmailRoutes, .getEmailRoute:
            return .get
        case .createEmailRoute:
            return .post
        case .deleteEmailRoute:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getEmailRoutes, .getEmailRoute, .deleteEmailRoute:
            return .requestPlain
        case .createEmailRoute(_, let customAddress, let destinationAddress):
            let parameters: [String: Any] = [
                "custom_address": customAddress,
                "destination_address": destinationAddress
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let apiToken = KeychainHelper.shared.read(service: "CloudflareService", account: "apiToken") {
            headers["Authorization"] = "Bearer \(apiToken)"
        }
        return headers
    }
}

class CloudflareService {
    private let provider = MoyaProvider<CloudflareAPI>()
    private var accountId: String {
        UserDefaults.standard.string(forKey: cloudflareAccountIdKey) ?? ""
    }

    func getEmailRoutes(completion: @escaping (Result<[EmailRoute], Error>) -> Void) {
        provider.request(.getEmailRoutes(accountId: accountId)) { result in
            switch result {
            case .success(let response):
                do {
                    let emailRoutes = try JSONDecoder().decode([EmailRoute].self, from: response.data)
                    completion(.success(emailRoutes))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createEmailRoute(customAddress: String, destinationAddress: String, completion: @escaping (Result<EmailRoute, Error>) -> Void) {
        provider.request(.createEmailRoute(accountId: accountId, customAddress: customAddress, destinationAddress: destinationAddress)) { result in
            switch result {
            case .success(let response):
                do {
                    let emailRoute = try JSONDecoder().decode(EmailRoute.self, from: response.data)
                    completion(.success(emailRoute))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteEmailRoute(destinationAddressIdentifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.deleteEmailRoute(accountId: accountId, destinationAddressIdentifier: destinationAddressIdentifier)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getEmailRoute(destinationAddressIdentifier: String, completion: @escaping (Result<EmailRoute, Error>) -> Void) {
        provider.request(.getEmailRoute(accountId: accountId, destinationAddressIdentifier: destinationAddressIdentifier)) { result in
            switch result {
            case .success(let response):
                do {
                    let emailRoute = try JSONDecoder().decode(EmailRoute.self, from: response.data)
                    completion(.success(emailRoute))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
