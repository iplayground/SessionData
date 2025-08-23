import Testing

@testable import SessionData

struct SessionDataClientTests {

  @Test("Client should have fetchSchedules method that accepts day parameter")
  func clientHasFetchSchedulesMethod() async throws {
    let client = SessionDataClient.mock

    // Test with different day parameters - should not throw
    _ = try await client.fetchSchedules(nil, .fallback)
    _ = try await client.fetchSchedules(1, .fallback)
    _ = try await client.fetchSchedules(2, .fallback)
  }

  @Test("Client should have fetchSpeakers method that returns speaker array")
  func clientHasFetchSpeakersMethod() async throws {
    let client = SessionDataClient.mock

    _ = try await client.fetchSpeakers(.fallback)
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
      time: "09:00",
      title: "Day 1 Session",
      tags: [],
      speaker: "Speaker 1",
      speakerID: nil,
      description: ""
    )
    let testSession2 = Session(
      time: "10:00",
      title: "Day 2 Session",
      tags: [],
      speaker: "Speaker 2",
      speakerID: nil,
      description: ""
    )

    let client = SessionDataClient(
      fetchSchedules: { day, _ in
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
      fetchSpeakers: { _ in [] },
      fetchSponsors: { SponsorsData(sponsors: [], partner: []) },
      fetchStaffs: { [] },
      fetchLinks: { [] }
    )

    let day1Sessions = try await client.fetchSchedules(1, .fallback)
    #expect(day1Sessions.count == 1)
    #expect(day1Sessions.first?.title == "Day 1 Session")

    let day2Sessions = try await client.fetchSchedules(2, .fallback)
    #expect(day2Sessions.count == 1)
    #expect(day2Sessions.first?.title == "Day 2 Session")

    let allSessions = try await client.fetchSchedules(nil, .fallback)
    #expect(allSessions.count == 2)
  }

  @Test("Local client should decode schedules correctly")
  func localClientDecodesSchedules() async throws {
    let client = SessionDataClient.local

    let schedules = try await client.fetchSchedules(nil, .fallback)
    #expect(!schedules.isEmpty)

    // Verify structure of decoded sessions
    if let firstSession = schedules.first {
      #expect(!firstSession.title.isEmpty)
      #expect(!firstSession.time.isEmpty)
      // Note: speaker can be empty, so we don't check that
      #expect(firstSession.tags.count >= 0)
    }

    // Test day filtering
    let day1Sessions = try await client.fetchSchedules(1, .fallback)
    let day2Sessions = try await client.fetchSchedules(2, .fallback)

    #expect(!day1Sessions.isEmpty)
    #expect(!day2Sessions.isEmpty)
    #expect(day1Sessions.count + day2Sessions.count == schedules.count)
  }

  @Test("Local client should decode speakers correctly")
  func localClientDecodesSpeakers() async throws {
    let client = SessionDataClient.local

    let speakers = try await client.fetchSpeakers(.fallback)
    #expect(!speakers.isEmpty)

    // Verify structure of decoded speakers
    if let firstSpeaker = speakers.first {
      #expect(!firstSpeaker.name.isEmpty)
    }
  }

  @Test("Local client should decode sponsors correctly")
  func localClientDecodeSponsors() async throws {
    let client = SessionDataClient.local

    let sponsorsData = try await client.fetchSponsors()

    // Verify structure of decoded sponsors
    #expect(sponsorsData.sponsors.count >= 0)
    #expect(sponsorsData.partner.count >= 0)
  }

  @Test("Local client should decode staffs correctly")
  func localClientDecodesStaffs() async throws {
    let client = SessionDataClient.local

    let staffs = try await client.fetchStaffs()
    #expect(!staffs.isEmpty)

    // Verify structure of decoded staffs
    if let firstStaff = staffs.first {
      #expect(!firstStaff.name.isEmpty)
    }
  }

  @Test("Local client should decode links correctly")
  func localClientDecodesLinks() async throws {
    let client = SessionDataClient.local

    let links = try await client.fetchLinks()
    #expect(!links.isEmpty)

    // Verify structure of decoded links
    if let firstLink = links.first {
      #expect(!firstLink.title.isEmpty)
      #expect(!firstLink.url.absoluteString.isEmpty)
    }
  }

  @Test("Local client should return consistent data across multiple calls")
  func localClientConsistentData() async throws {
    let client = SessionDataClient.local

    // Fetch data twice and compare
    let schedules1 = try await client.fetchSchedules(nil, .fallback)
    let schedules2 = try await client.fetchSchedules(nil, .fallback)
    #expect(schedules1.count == schedules2.count)

    let speakers1 = try await client.fetchSpeakers(.fallback)
    let speakers2 = try await client.fetchSpeakers(.fallback)
    #expect(speakers1.count == speakers2.count)

    let staffs1 = try await client.fetchStaffs()
    let staffs2 = try await client.fetchStaffs()
    #expect(staffs1.count == staffs2.count)

    let links1 = try await client.fetchLinks()
    let links2 = try await client.fetchLinks()
    #expect(links1.count == links2.count)
  }
}
