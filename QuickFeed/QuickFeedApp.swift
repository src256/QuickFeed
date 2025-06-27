//
//  QuickFeedApp.swift
//  QuickFeed
//
//  Created by sora on 2025/06/26.
//

import SwiftUI

@main
struct QuickFeedApp: App {
    @StateObject private var feedManager = RSSFeedManager()
    
    var body: some Scene {
        MenuBarExtra("QuickFeed", systemImage: "antenna.radiowaves.left.and.right") {
            MenuView()
                .environmentObject(feedManager)
        }
        .menuBarExtraStyle(.window)
    }
}
