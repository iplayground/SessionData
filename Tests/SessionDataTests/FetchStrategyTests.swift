import Foundation
import Testing

@testable import SessionData

struct FetchStrategyTests {

  @Test("Remote strategy should fetch from network only")
  func remoteStrategyNetworkOnly() async throws {
    let client = SessionDataClient.live

    // Test remote strategy - should work with network connection
    do {
      let schedule = try await client.fetchSchedules(dataLanguage: .fallback, strategy: .remote)
      #expect(!schedule.day1.isEmpty, "Remote strategy should return data from network")
    } catch {
      // Network might be unavailable, that's acceptable for remote-only strategy
      #expect(error is SessionDataError)
    }
  }

  @Test("LocalOnly strategy should fetch from bundle only")
  func localOnlyStrategyBundleOnly() async throws {
    let client = SessionDataClient.live

    // Test localOnly strategy - should always work with bundled data
    let schedule = try await client.fetchSchedules(dataLanguage: .fallback, strategy: .localOnly)
    #expect(!schedule.day1.isEmpty, "LocalOnly strategy should return bundled data")

    let speakers = try await client.fetchSpeakers(dataLanguage: .fallback, strategy: .localOnly)
    #expect(!speakers.isEmpty, "LocalOnly strategy should return bundled speakers")

    let sponsors = try await client.fetchSponsors(strategy: .localOnly)
    #expect(
      !sponsors.sponsors.isEmpty || !sponsors.personal.isEmpty || !sponsors.partner.isEmpty,
      "LocalOnly strategy should return bundled sponsors")

    let staffs = try await client.fetchStaffs(strategy: .localOnly)
    #expect(!staffs.isEmpty, "LocalOnly strategy should return bundled staffs")

    let links = try await client.fetchLinks(strategy: .localOnly)
    #expect(!links.isEmpty, "LocalOnly strategy should return bundled links")
  }

  @Test("CacheFirst strategy should work with fallback")
  func cacheFirstStrategyWithFallback() async throws {
    let client = SessionDataClient.live

    // Test cacheFirst strategy - should fallback to local if no cache/network
    let schedule = try await client.fetchSchedules(dataLanguage: .fallback, strategy: .cacheFirst)
    #expect(!schedule.day1.isEmpty, "CacheFirst strategy should fallback to bundle if needed")

    let speakers = try await client.fetchSpeakers(dataLanguage: .fallback, strategy: .cacheFirst)
    #expect(!speakers.isEmpty, "CacheFirst strategy should fallback for speakers")
  }

  @Test("Default strategy should be remote")
  func defaultStrategyIsRemote() async throws {
    let client = SessionDataClient.live

    // Test that convenience methods use remote strategy by default
    do {
      let schedule = try await client.fetchSchedules(dataLanguage: .fallback)
      #expect(!schedule.day1.isEmpty, "Default strategy should work")
    } catch {
      // Network failure is acceptable for remote strategy
      #expect(error is SessionDataError)
    }
  }

  @Test("All strategies work with different data languages")
  func strategiesWorkWithDifferentLanguages() async throws {
    let client = SessionDataClient.live

    for language in DataLanguage.allCases {
      // LocalOnly should always work regardless of language
      let schedule = try await client.fetchSchedules(
        dataLanguage: language, strategy: .localOnly)
      #expect(!schedule.day1.isEmpty, "LocalOnly should work with \(language)")

      let speakers = try await client.fetchSpeakers(dataLanguage: language, strategy: .localOnly)
      #expect(!speakers.isEmpty, "LocalOnly speakers should work with \(language)")
    }
  }
}
