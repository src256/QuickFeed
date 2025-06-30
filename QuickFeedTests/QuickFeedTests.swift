//
//  QuickFeedTests.swift
//  QuickFeedTests
//
//  Created by sora on 2025/06/27.
//

import Testing
import Foundation
@testable import QuickFeed

@MainActor
struct QuickFeedTests {

    @Test func testDefaultFeedURL() async throws {
        let feedManager = RSSFeedManager()
        let defaultURL = "https://softantenna.com/folders/feed.rss"
        
        #expect(feedManager.feedURL == defaultURL)
    }
    
    @Test func testFeedURLPersistence() async throws {
        let feedManager = RSSFeedManager()
        let testURL = "https://example.com/test.rss"
        
        feedManager.feedURL = testURL
        #expect(feedManager.feedURL == testURL)
        
        #expect(UserDefaults.standard.string(forKey: "RSSFeedURL") == testURL)
    }
    
    @Test func testUpdateFeedURL() async throws {
        let feedManager = RSSFeedManager()
        let newURL = "https://example.com/new-feed.rss"
        
        feedManager.updateFeedURL(newURL)
        #expect(feedManager.feedURL == newURL)
    }
    
    @Test func testFeedURLFromUserDefaults() async throws {
        let testURL = "https://example.com/stored.rss"
        UserDefaults.standard.set(testURL, forKey: "RSSFeedURL")
        
        let feedManager = RSSFeedManager()
        #expect(feedManager.feedURL == testURL)
        
        UserDefaults.standard.removeObject(forKey: "RSSFeedURL")
    }

}
