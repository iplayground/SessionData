import Testing
import Foundation
@testable import SessionData

struct LiveSessionDataClientErrorTests {
  
  @Test("Should test cache fallback when network fails")
  func testNetworkFailureFallbackToCache() async throws {
    // Create a cache directory and save test data
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)
    
    let testSchedule = Schedule(
      day1: [Session(time: "09:00", title: "Cached Session", tags: [], speaker: "Cached Speaker", description: "From cache")],
      day2: []
    )
    let cacheData = try JSONEncoder().encode(testSchedule)
    await cacheManager.save(cacheData, for: "schedule.json")
    
    // Create a network fetcher that always fails
    struct FailingNetworkFetcher: NetworkFetching {
      func fetch(endpoint: String) async throws -> Data {
        throw URLError(.networkConnectionLost)
      }
    }
    
    let client = LiveSessionDataClient(
      networkFetcher: FailingNetworkFetcher(),
      cacheManager: cacheManager,
      bundleLoader: BundleLoader()
    )
    
    // Should fall back to cache
    let sessions = try await client.fetchSchedules(day: nil as Int?)
    #expect(sessions.count == 1)
    #expect(sessions[0].title == "Cached Session")
  }
  
  @Test("Should test bundle fallback when both network and cache fail")
  func testBundleFallbackWhenAllElseFails() async throws {
    // Create empty cache manager
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)
    
    // Create network fetcher that fails
    struct FailingNetworkFetcher: NetworkFetching {
      func fetch(endpoint: String) async throws -> Data {
        throw URLError(.networkConnectionLost)
      }
    }
    
    let client = LiveSessionDataClient(
      networkFetcher: FailingNetworkFetcher(),
      cacheManager: cacheManager,
      bundleLoader: BundleLoader()
    )
    
    // Should fall back to bundle - this will load real JSON from bundle
    let sessions = try await client.fetchSchedules(day: nil as Int?)
    #expect(!sessions.isEmpty) // Bundle should have data
  }
  
  @Test("Should test all endpoints with bundle fallback")
  func testAllEndpointsBundleFallback() async throws {
    struct FailingNetworkFetcher: NetworkFetching {
      func fetch(endpoint: String) async throws -> Data {
        throw URLError(.networkConnectionLost)
      }
    }
    
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)
    
    let client = LiveSessionDataClient(
      networkFetcher: FailingNetworkFetcher(),
      cacheManager: cacheManager,
      bundleLoader: BundleLoader()
    )
    
    // Test all endpoints fall back to bundle
    let speakers = try await client.fetchSpeakers()
    #expect(!speakers.isEmpty)
    
    let sponsors = try await client.fetchSponsors()
    #expect(!sponsors.sponsors.isEmpty || !sponsors.partner.isEmpty)
    
    let staffs = try await client.fetchStaffs()
    #expect(!staffs.isEmpty)
  }
  
  @Test("Should test cache manager load functionality")
  func testCacheManagerLoad() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)
    
    let testKey = "test.json"
    let testData = "Test cache data".data(using: .utf8)!
    
    // Test saving and loading
    await cacheManager.save(testData, for: testKey)
    
    let loadedData = await cacheManager.load(for: testKey)
    #expect(loadedData == testData, "Loaded data should match saved data")
    
    // Test loading non-existent key
    let nonExistentKey = "nonexistent.json"
    let missingData = await cacheManager.load(for: nonExistentKey)
    #expect(missingData == nil, "Loading non-existent key should return nil")
  }
  
  @Test("Should test network error handling")
  func testNetworkErrors() async throws {
    struct ErrorNetworkFetcher: NetworkFetching {
      let error: Error
      func fetch(endpoint: String) async throws -> Data {
        throw error
      }
    }
    
    // Test with different network errors
    let networkTimeoutFetcher = ErrorNetworkFetcher(error: URLError(.timedOut))
    let networkNotFoundFetcher = ErrorNetworkFetcher(error: URLError(.fileDoesNotExist))
    
    let uniqueDir1 = "TestCache_\(UUID().uuidString)"
    let cacheManager1 = CacheManager(directory: uniqueDir1)
    
    let uniqueDir2 = "TestCache_\(UUID().uuidString)"
    let cacheManager2 = CacheManager(directory: uniqueDir2)
    
    let client1 = LiveSessionDataClient(
      networkFetcher: networkTimeoutFetcher,
      cacheManager: cacheManager1,
      bundleLoader: BundleLoader()
    )
    
    let client2 = LiveSessionDataClient(
      networkFetcher: networkNotFoundFetcher,
      cacheManager: cacheManager2,
      bundleLoader: BundleLoader()
    )
    
    // Both should fall back to bundle and succeed
    let sessions1 = try await client1.fetchSchedules(day: 1)
    #expect(!sessions1.isEmpty)
    
    let sessions2 = try await client2.fetchSchedules(day: 1) // Use day 1 which we know has data
    #expect(!sessions2.isEmpty)
  }
}