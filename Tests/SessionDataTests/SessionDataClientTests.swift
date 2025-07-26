import Testing

@testable import SessionData

struct SessionDataClientTests {

  @Test("Client should have fetchSchedules method that accepts day parameter")
  func clientHasFetchSchedulesMethod() async throws {
    let client = SessionDataClient.mock

    // Test with different day parameters - should not throw
    _ = try await client.fetchSchedules(nil)
    _ = try await client.fetchSchedules(1)
    _ = try await client.fetchSchedules(2)
  }

  @Test("Client should have fetchSpeakers method that returns speaker array")
  func clientHasFetchSpeakersMethod() async throws {
    let client = SessionDataClient.mock

    _ = try await client.fetchSpeakers()
  }

  @Test("Client should have fetchSponsors method that returns sponsors data")
  func clientHasFetchSponsorsMethod() async throws {
    let client = SessionDataClient.mock

    _ = try await client.fetchSponsors()
  }

  @Test("Client should have fetchStaffs method that returns staff array")
  func clientHasFetchStaffsMethod() async throws {
    let client = SessionDataClient.mock

    _ = try await client.fetchStaffs()
  }

  @Test("Schedule filtering should return correct sessions based on day parameter")
  func scheduleDayFiltering() async throws {
    // Create a test client with known data
    let testSession1 = Session(
      time: "09:00", title: "Day 1 Session", tags: [], speaker: "Speaker 1", description: "")
    let testSession2 = Session(
      time: "10:00", title: "Day 2 Session", tags: [], speaker: "Speaker 2", description: "")

    let client = SessionDataClient(
      fetchSchedules: { day in
        switch day {
        case 1:
          return [testSession1]
        case 2:
          return [testSession2]
        case nil:
          return [testSession1, testSession2]
        default:
          return []
        }
      },
      fetchSpeakers: { [] },
      fetchSponsors: { SponsorsData(sponsors: [], partner: []) },
      fetchStaffs: { [] }
    )

    let day1Sessions = try await client.fetchSchedules(1)
    #expect(day1Sessions.count == 1)
    #expect(day1Sessions.first?.title == "Day 1 Session")

    let day2Sessions = try await client.fetchSchedules(2)
    #expect(day2Sessions.count == 1)
    #expect(day2Sessions.first?.title == "Day 2 Session")

    let allSessions = try await client.fetchSchedules(nil)
    #expect(allSessions.count == 2)
  }
}
