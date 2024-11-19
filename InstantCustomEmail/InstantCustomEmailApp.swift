//
//  InstantCustomEmailApp.swift
//  InstantCustomEmail
//
//  Created by Mriyam Tamuli on 14/11/24.
//

import SwiftUI

@main
struct InstantCustomEmailApp: App {
    @StateObject private var emailRoutesViewModel = EmailRoutesViewModel()

    var body: some Scene {
        WindowGroup {
            EmailRoutesView(viewModel: emailRoutesViewModel)
        }
    }
}
