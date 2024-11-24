//
//  DestinationAddress.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

import Foundation

struct DestinationAddress: Identifiable, Codable, Hashable {
    let id: String  // Unique identifier for the destination address
    let email: String  // Destination email address
    let created: String  // Creation timestamp
    let modified: String  // Last modified timestamp
    let tag: String  // Tag associated with the destination address
    let verified: String?  // Verification timestamp (optional)
}

// MARK: - Sample Data
extension DestinationAddress {
    static let sampleData: [DestinationAddress] = [
        DestinationAddress(id: "1", email: "user+finance@gmail.com", created: "2024-11-23T12:00:00Z", modified: "2024-11-23T12:00:00Z", tag: "finance", verified: "2024-11-23T12:00:00Z"),
        DestinationAddress(id: "2", email: "user+gaming@gmail.com", created: "2024-11-23T12:00:00Z", modified: "2024-11-23T12:00:00Z", tag: "gaming", verified: nil),
        DestinationAddress(id: "3", email: "user+banking@gmail.com", created: "2024-11-23T12:00:00Z", modified: "2024-11-23T12:00:00Z", tag: "banking", verified: "2024-11-23T12:00:00Z"),
    ]
}
