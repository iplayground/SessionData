import Foundation
import Testing

@testable import SessionData

struct LiveClientIntegrationTests {

  @Test("Live client integration should successfully fetch all data types from bundle fallback")
  func liveClientCanFetchFromBundle() async throws {
    let client = SessionDataClient.live

    // Test fetching schedules - should fall back to bundle if network fails
    let allSchedules = try await client.fetchSchedules(nil, .fallback)
    #expect(!allSchedules.isEmpty)

    let day1Schedules = try await client.fetchSchedules(1, .fallback)
    #expect(!day1Schedules.isEmpty)

    // Test fetching speakers
    let speakers = try await client.fetchSpeakers(.fallback)
    #expect(!speakers.isEmpty)

    // Test fetching sponsors
    let sponsors = try await client.fetchSponsors()
    #expect(!sponsors.sponsors.isEmpty || !sponsors.partner.isEmpty)

    // Test fetching staffs
    let staffs = try await client.fetchStaffs()
    #expect(!staffs.isEmpty)
  }
}
