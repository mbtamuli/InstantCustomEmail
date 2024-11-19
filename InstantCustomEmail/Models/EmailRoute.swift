
import Foundation

struct EmailRoute: Identifiable, Codable {
    var id: String
    var customAddress: String
    var destinationAddress: String
}
