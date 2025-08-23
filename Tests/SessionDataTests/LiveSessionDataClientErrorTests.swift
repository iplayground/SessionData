import Foundation
import Testing

@testable import SessionData

struct LiveSessionDataClientErrorTests {

  @Test("Network failure triggers fallback chain to cache")
  func testFallbackChainWhenNetworkFails() async throws {
    // Create a mock network fetcher that always fails
    let failingNetworkFetcher = FailingNetworkFetcher()
    let cacheManager = CacheManager(directory: "TestCache_\(UUID().uuidString)")
    let bundleLoader = BundleLoader()
    
    // Pre-populate cache with test data
    let cachedSchedule = Schedule(
      day1: [
        Session(
          time: "09:00",
          title: "Cached Session",
          tags: [],
          speaker: "Cached Speaker",
          speakerID: nil,
          description: "From cache"
        )
      ],
      day2: []
    )
    
    let cachedData = try JSONEncoder().encode(cachedSchedule)
    await cacheManager.save(cachedData, for: "schedule.json")
    
    let client = LiveSessionDataClient(
      networkFetcher: failingNetworkFetcher,
      cacheManager: cacheManager,
      bundleLoader: bundleLoader
    )
    
    // Should fall back to cache when network fails
    let sessions = try await client.fetchSchedules(day: nil, dataLanguage: .fallback, strategy: .remote)
    #expect(sessions.count == 1)
    #expect(sessions[0].title == "Cached Session")
  }

  @Test("Network and cache failure triggers bundle fallback")
  func testFallbackToBundleWhenNetworkAndCacheFail() async throws {
    let failingNetworkFetcher = FailingNetworkFetcher()
    let cacheManager = CacheManager(directory: "EmptyTestCache_\(UUID().uuidString)")
    let bundleLoader = BundleLoader()
    
    let client = LiveSessionDataClient(
      networkFetcher: failingNetworkFetcher,
      cacheManager: cacheManager,
      bundleLoader: bundleLoader
    )
    
    // Should fall back to bundle - this will load real JSON from bundle
    let sessions = try await client.fetchSchedules(day: nil, dataLanguage: .fallback, strategy: .remote)
    #expect(!sessions.isEmpty, "Should have bundle data")
  }

  @Test("All endpoints fallback to bundle when network fails")
  func testAllEndpointsWithFallback() async throws {
    let failingNetworkFetcher = FailingNetworkFetcher()
    let cacheManager = CacheManager(directory: "EmptyTestCache_\(UUID().uuidString)")
    let bundleLoader = BundleLoader()
    
    let client = LiveSessionDataClient(
      networkFetcher: failingNetworkFetcher,
      cacheManager: cacheManager,
      bundleLoader: bundleLoader
    )
    
    // Test all endpoints fall back to bundle
    let speakers = try await client.fetchSpeakers(dataLanguage: .fallback, strategy: .remote)
    #expect(!speakers.isEmpty)
    
    let sponsors = try await client.fetchSponsors(strategy: .remote)
    #expect(!sponsors.sponsors.isEmpty || !sponsors.partner.isEmpty)
    
    let staffs = try await client.fetchStaffs(strategy: .remote)
    #expect(!staffs.isEmpty)
    
    let links = try await client.fetchLinks(strategy: .remote)
    #expect(!links.isEmpty)
  }

  @Test("Day filtering works with bundle fallback")
  func testDayFilteringWithFallback() async throws {
    let failingNetworkFetcher = FailingNetworkFetcher()
    let cacheManager = CacheManager(directory: "EmptyTestCache_\(UUID().uuidString)")
    let bundleLoader = BundleLoader()
    
    let client = LiveSessionDataClient(
      networkFetcher: failingNetworkFetcher,
      cacheManager: cacheManager,
      bundleLoader: bundleLoader
    )
    
    // Test day filtering works with bundle fallback
    let day1Sessions = try await client.fetchSchedules(day: 1, dataLanguage: .fallback, strategy: .remote)
    #expect(!day1Sessions.isEmpty)
    
    let day2Sessions = try await client.fetchSchedules(day: 2, dataLanguage: .fallback, strategy: .remote)
    #expect(!day2Sessions.isEmpty)
    
    let invalidDaySessions = try await client.fetchSchedules(day: 99, dataLanguage: .fallback, strategy: .remote)
    #expect(invalidDaySessions.isEmpty, "Invalid day should return empty array")
  }

  @Test("All languages work with bundle fallback")
  func testDifferentLanguagesWithFallback() async throws {
    let failingNetworkFetcher = FailingNetworkFetcher()
    let cacheManager = CacheManager(directory: "EmptyTestCache_\(UUID().uuidString)")
    let bundleLoader = BundleLoader()
    
    let client = LiveSessionDataClient(
      networkFetcher: failingNetworkFetcher,
      cacheManager: cacheManager,
      bundleLoader: bundleLoader
    )
    
    // Test all languages work with bundle fallback
    for language in DataLanguage.allCases {
      let sessions = try await client.fetchSchedules(day: 1, dataLanguage: language, strategy: .remote)
      #expect(!sessions.isEmpty, "Should have sessions for \(language)")
      
      let speakers = try await client.fetchSpeakers(dataLanguage: language, strategy: .remote)
      #expect(!speakers.isEmpty, "Should have speakers for \(language)")
    }
  }
}

// MARK: - Mock Implementations

struct FailingNetworkFetcher: NetworkFetching {
  func fetch(endpoint: String) async throws -> Data {
    throw SessionDataError.networkError
  }
}