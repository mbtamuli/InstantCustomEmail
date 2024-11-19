
import Foundation

struct EmailAlias: Identifiable, Codable {
    var id: String
    var alias: String
    var destination: String
}
