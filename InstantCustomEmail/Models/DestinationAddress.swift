//
//  DestinationAddress.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//
import Foundation

struct DestinationAddress: Identifiable, Codable {
    let id: String  // Unique identifier for the destination address
    let email: String  // Destination email address
    let created: String  // Creation timestamp
    let modified: String  // Last modified timestamp
    let tag: String  // Tag associated with the destination address
    let verified: String?  // Verification timestamp (optional)
}
