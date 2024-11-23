//
//  RoutingRule.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/23/24.
//

struct RoutingRule: Identifiable, Codable {
    let id: String
    let tag: String?
    let name: String?
    let matchers: [Matcher]
    let actions: [Action]
    let enabled: Bool
    let priority: Int

    struct Matcher: Codable {
        let type: String?
        let field: String?
        let value: String?
    }

    struct Action: Codable {
        let type: String
        let value: [String]?
    }
}
