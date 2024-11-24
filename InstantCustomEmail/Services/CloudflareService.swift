import Foundation
import Combine
import Moya

// MARK: - CloudflareAPI TargetType Enum

enum CloudflareAPI {
    // Destination Addresses
    case listDestinationAddresses(accountId: String)
    case createDestinationAddress(accountId: String, email: String)
    case deleteDestinationAddress(accountId: String, destinationAddressIdentifier: String)
    case getDestinationAddress(accountId: String, destinationAddressIdentifier: String)

    // Routing Rules
    case listRoutingRules(zoneId: String)
    case createRoutingRule(zoneId: String, rule: RoutingRule)
    case deleteRoutingRule(zoneId: String, ruleId: String)
    case getRoutingRule(zoneId: String, ruleId: String)
    case getCatchAllRule(zoneId: String)
    case updateCatchAllRule(zoneId: String, rule: RoutingRule)

    // Token Verification
    case verifyToken
}

extension CloudflareAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cloudflare.com/client/v4")!
    }

    var path: String {
        switch self {
        // Destination Addresses
        case .listDestinationAddresses(let accountId):
            return "/accounts/\(accountId)/email/routing/addresses"
        case .createDestinationAddress(let accountId, _):
            return "/accounts/\(accountId)/email/routing/addresses"
        case .deleteDestinationAddress(let accountId, let destinationAddressIdentifier):
            return "/accounts/\(accountId)/email/routing/addresses/\(destinationAddressIdentifier)"
        case .getDestinationAddress(let accountId, let destinationAddressIdentifier):
            return "/accounts/\(accountId)/email/routing/addresses/\(destinationAddressIdentifier)"

        // Routing Rules
        case .listRoutingRules(let zoneId):
            return "/zones/\(zoneId)/email/routing/rules"
        case .createRoutingRule(let zoneId, _):
            return "/zones/\(zoneId)/email/routing/rules"
        case .deleteRoutingRule(let zoneId, let ruleId):
            return "/zones/\(zoneId)/email/routing/rules/\(ruleId)"
        case .getRoutingRule(let zoneId, let ruleId):
            return "/zones/\(zoneId)/email/routing/rules/\(ruleId)"
        case .getCatchAllRule(let zoneId):
            return "/zones/\(zoneId)/email/routing/rules/catch_all"
        case .updateCatchAllRule(let zoneId, _):
            return "/zones/\(zoneId)/email/routing/rules/catch_all"

        // Token Verification
        case .verifyToken:
            return "/user/tokens/verify"
        }
    }

    var method: Moya.Method {
        switch self {
        case .listDestinationAddresses, .getDestinationAddress, .listRoutingRules, .getRoutingRule, .getCatchAllRule, .verifyToken:
            return .get
        case .createDestinationAddress, .createRoutingRule:
            return .post
        case .deleteDestinationAddress, .deleteRoutingRule:
            return .delete
        case .updateCatchAllRule:
            return .put
        }
    }

    var task: Task {
        switch self {
        case .listDestinationAddresses, .getDestinationAddress, .listRoutingRules, .getRoutingRule, .getCatchAllRule, .verifyToken:
            return .requestPlain
        case .createDestinationAddress(_, let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .createRoutingRule(_, let rule), .updateCatchAllRule(_, let rule):
            return .requestJSONEncodable(rule)
        case .deleteDestinationAddress, .deleteRoutingRule:
            return .requestPlain
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

// MARK: - CloudflareService

class CloudflareService {
    private let provider = MoyaProvider<CloudflareAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    private var accountId: String? {
        return UserDefaults.standard
            .string(forKey: Constants.cloudflareAccountIdKey)
    }

    private var zoneId: String? {
        return UserDefaults.standard
            .string(forKey: Constants.cloudflareZoneIdKey)
    }

    // MARK: Email Routes

    func listDestinationAddresses(completion: @escaping (Result<[DestinationAddress], Error>) -> Void) {
        guard let accountId = accountId, !accountId.isEmpty else {
            completion(.failure(CloudflareServiceError.accountIdNotSet))
            return
        }
        print("Account ID: \(accountId)")  // For debugging purposes
        provider.request(.listDestinationAddresses(accountId: accountId)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func createDestinationAddress(email: String, completion: @escaping (Result<DestinationAddress, Error>) -> Void) {
        guard let accountId = accountId, !accountId.isEmpty else {
            completion(.failure(CloudflareServiceError.accountIdNotSet))
            return
        }
        provider.request(.createDestinationAddress(accountId: accountId, email: email)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func deleteDestinationAddress(identifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accountId = accountId, !accountId.isEmpty else {
            completion(.failure(CloudflareServiceError.accountIdNotSet))
            return
        }
        provider.request(.deleteDestinationAddress(accountId: accountId, destinationAddressIdentifier: identifier)) { result in
            switch result {
            case .success(let response):
                do {
                    // Decode response with EmptyResponse
                    let apiResponse = try JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: response.data)
                    if apiResponse.success {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "API returned errors: \(apiResponse.errors)"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getDestinationAddress(identifier: String, completion: @escaping (Result<DestinationAddress, Error>) -> Void) {
        guard let accountId = accountId, !accountId.isEmpty else {
            completion(.failure(CloudflareServiceError.accountIdNotSet))
            return
        }
        provider.request(.getDestinationAddress(accountId: accountId, destinationAddressIdentifier: identifier)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    // MARK: Routing Rules

    func listRoutingRules(completion: @escaping (Result<[RoutingRule], Error>) -> Void) {
        guard let zoneId = zoneId, !zoneId.isEmpty else {
            completion(.failure(CloudflareServiceError.zoneIdNotSet))
            return
        }
        provider.request(.listRoutingRules(zoneId: zoneId)) { result in
            switch result {
            case .success(let response):
                do {
                    let apiResponse = try JSONDecoder().decode(RoutingRulesResponse.self, from: response.data)
                    if apiResponse.success {
                        completion(.success(apiResponse.result))
                    } else {
                        let error = NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "API returned errors: \(apiResponse.errors)"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func createRoutingRule(rule: RoutingRule, completion: @escaping (Result<RoutingRule, Error>) -> Void) {
        guard let zoneId = zoneId, !zoneId.isEmpty else {
            completion(.failure(CloudflareServiceError.zoneIdNotSet))
            return
        }
        provider.request(.createRoutingRule(zoneId: zoneId, rule: rule)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func deleteRoutingRule(ruleId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let zoneId = zoneId, !zoneId.isEmpty else {
            completion(.failure(CloudflareServiceError.zoneIdNotSet))
            return
        }
        provider.request(.deleteRoutingRule(zoneId: zoneId, ruleId: ruleId)) { result in
            switch result {
            case .success(let response):
                do {
                    // Decode response with EmptyResponse
                    let apiResponse = try JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: response.data)
                    if apiResponse.success {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "API returned errors: \(apiResponse.errors)"])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRoutingRule(ruleId: String, completion: @escaping (Result<RoutingRule, Error>) -> Void) {
        guard let zoneId = zoneId, !zoneId.isEmpty else {
            completion(.failure(CloudflareServiceError.zoneIdNotSet))
            return
        }
        provider.request(.getRoutingRule(zoneId: zoneId, ruleId: ruleId)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func getCatchAllRule(completion: @escaping (Result<RoutingRule, Error>) -> Void) {
        guard let zoneId = zoneId, !zoneId.isEmpty else {
            completion(.failure(CloudflareServiceError.zoneIdNotSet))
            return
        }
        provider.request(.getCatchAllRule(zoneId: zoneId)) { result in
            self.handleResponse(result, completion: completion)
        }
    }

    func updateCatchAllRule(rule: RoutingRule, completion: @escaping (Result<RoutingRule, Error>) -> Void) {
        guard let zoneId = zoneId, !zoneId.isEmpty else {
            completion(.failure(CloudflareServiceError.zoneIdNotSet))
            return
        }
        provider.request(.updateCatchAllRule(zoneId: zoneId, rule: rule)) { result in
            self.handleResponse(result, completion: completion)
        }
    }


    // MARK: Token Verification

    func verifyToken(completion: @escaping (Result<VerifyTokenResponse, Error>) -> Void) {
        provider.request(.verifyToken) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(VerifyTokenResponse.self, from: response.data)
                    if decodedResponse.success {
                        completion(.success(decodedResponse))
                    } else {
                        let apiErrorDescription = "API returned errors: \(decodedResponse.errors)"
                        completion(.failure(NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: apiErrorDescription])))
                    }
                } catch {
                    let decodingErrorDescription = "Error decoding response: \(error.localizedDescription)"
                    completion(.failure(NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: decodingErrorDescription])))
                }
            case .failure(let error):
                let networkErrorDescription = "Network error: \(error.localizedDescription)"
                completion(.failure(NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: networkErrorDescription])))
            }
        }
    }

    // MARK: Response Handling

    private func handleResponse<T: Decodable>(_ result: Result<Response, MoyaError>, completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case .success(let response):
            // Log non-200 status codes
            if response.statusCode != 200 {
                let errorDescription = "Received non-200 status code: \(response.statusCode), Response: \(String(describing: response))"
                print(errorDescription)
            }

            // Handle rate limiting (HTTP 429)
            if response.statusCode == 429,
               let retryAfterHeader = response.response?.allHeaderFields["retry-after"] as? String,
               let retryAfter = Int(retryAfterHeader) {
                let rateLimitErrorDescription = "Rate limit exceeded. Please wait for \(retryAfter) seconds."
                print(rateLimitErrorDescription)
                completion(.failure(NSError(domain: "CloudflareAPI", code: 429, userInfo: [NSLocalizedDescriptionKey: rateLimitErrorDescription])))
                return
            }

            // Attempt to decode the response
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse<T>.self, from: response.data)
                print("Decoded response: \(decodedResponse)") // Debug print for decoded data
                if decodedResponse.success {
                    if let result = decodedResponse.result {
                        completion(.success(result))
                    } else {
                        let missingResultErrorDescription = "API response success but no result returned."
                        print(missingResultErrorDescription)
                        completion(.failure(NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: missingResultErrorDescription])))
                    }
                } else {
                    let apiErrorDescription = "API returned errors: \(decodedResponse.errors)"
                    print(apiErrorDescription)
                    completion(.failure(NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: apiErrorDescription])))
                }
            } catch {
                let decodingErrorDescription = "Error decoding response: \(error.localizedDescription)"
                print(decodingErrorDescription)
                completion(.failure(NSError(domain: "CloudflareAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: decodingErrorDescription])))
            }

        case .failure(let error):
            let networkErrorDescription = "Network error: \(error.localizedDescription)"
            print(networkErrorDescription)
            completion(.failure(error))
        }
    }
}

// MARK: - Supporting Models

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let errors: [String]
    let messages: [APIMessage]
    let result: T?
}

struct VerifyTokenResponse: Decodable {
    let result: VerifyTokenResult
    let success: Bool
    let errors: [String]
    let messages: [APIMessage]
}

struct VerifyTokenResult: Decodable {
    let id: String
    let status: String
    let expires_on: String
}

struct APIMessage: Decodable {
    let code: Int
    let message: String
    let type: String?
}

struct RoutingRulesResponse: Codable {
    let result: [RoutingRule]
    let success: Bool
    let errors: [String]
    let messages: [String]
    let result_info: ResultInfo
}

struct ResultInfo: Codable {
    let page: Int
    let per_page: Int
    let count: Int
    let total_count: Int
}

/// A placeholder for API responses with no meaningful `result` data.
struct EmptyResponse: Decodable {}

// MARK: - CloudflareServiceError

enum CloudflareServiceError: Error, LocalizedError {
    case accountIdNotSet
    case zoneIdNotSet

    var errorDescription: String? {
        switch self {
        case .accountIdNotSet:
            return "Account ID is not set"
        case .zoneIdNotSet:
            return "Zone ID is not set"
        }
    }
}
