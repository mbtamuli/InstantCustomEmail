//
//  DestinationListItemView.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 11/24/24.
//

import SwiftUI

struct DestinationListItemView: View {
    let address: DestinationAddress
    let routingRulesCount: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading) {
                // Target name at the top
                HStack {
                    Image(systemName: "target")
                        .foregroundColor(.accentColor)
                    Text(address.email)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .layoutPriority(1)
                }

                Divider()

                // Verification status and rules count at the bottom
                HStack {
                    if address.verified != nil {
                        Label("Verified", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Label("Unverified", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Label("\(routingRulesCount) Rules", systemImage: "list.number")
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
            }
            .padding()
        }
    }
}

#Preview() {
    DestinationListItemView(address: DestinationAddress.sampleData[1], routingRulesCount: 3)
}
