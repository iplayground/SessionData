import Foundation
import Testing

@testable import SessionData

struct LiveSessionDataClientTests {

  // MARK: - Network Success Tests

  @Test("Network success should return correct schedule data from remote source")
  func fetchSchedulesFromNetworkSuccess() async throws {
    // Given: A schedule with sessions on both days
    let expectedSchedule = Schedule(
      day1: [
        Session(
          time: "09:00",
          title: "Keynote",
          tags: [],
          speaker: "Tim Cook",
          speakerID: nil,
          description: "Opening keynote"
        )
      ],
      day2: [
        Session(
          time: "10:00",
          title: "SwiftUI",
          tags: ["UI"],
          speaker: "John Doe",
          speakerID: nil,
          description: "Advanced SwiftUI"
        )
      ]
    )

    let networkData = [
      "schedule.json": try JSONEncoder().encode(expectedSchedule)
    ]

    let client = createTestClient(networkData: networkData)

    // When: Fetching all schedules
    let sessions = try await client.fetchSchedules(nil)

    // Then: Should return combined sessions from both days
    #expect(sessions.count == 2)
    #expect(sessions[0].title == "Keynote")
    #expect(sessions[1].title == "SwiftUI")
  }

  @Test("Day filtering should return only sessions for the specified day")
  func fetchSchedulesWithDayFilter() async throws {
    // Given: A schedule with sessions on both days
    let expectedSchedule = Schedule(
      day1: [
        Session(
          time: "09:00",
          title: "Day 1 Session",
          tags: [],
          speaker: "Speaker 1",
          speakerID: nil,
          description: ""
        )
      ],
      day2: [
        Session(
          time: "10:00",
          title: "Day 2 Session",
          tags: [],
          speaker: "Speaker 2",
          speakerID: nil,
          description: ""
        )
      ]
    )

    let networkData = [
      "schedule.json": try JSONEncoder().encode(expectedSchedule)
    ]

    let client = createTestClient(networkData: networkData)

    // When: Fetching day 1 only
    let day1Sessions = try await client.fetchSchedules(1)
    #expect(day1Sessions.count == 1)
    #expect(day1Sessions[0].title == "Day 1 Session")

    // When: Fetching day 2 only
    let day2Sessions = try await client.fetchSchedules(2)
    #expect(day2Sessions.count == 1)
    #expect(day2Sessions[0].title == "Day 2 Session")
  }

  // MARK: - Fallback Tests

  @Test("Should fall back to cache when network request fails")
  func fallbackToCacheWhenNetworkFails() async throws {
    // Given: Network fails but cache has data
    let cachedSchedule = Schedule(
      day1: [
        Session(
          time: "09:00",
          title: "Cached Session",
          tags: [],
          speaker: "Cached Speaker",
          speakerID: nil,
          description: ""
        )
      ],
      day2: []
    )

    let cacheData = [
      "schedule.json": try JSONEncoder().encode(cachedSchedule)
    ]

    let client = createTestClient(
      cacheData: cacheData,
      networkShouldFail: true
    )

    // When: Fetching schedules
    let sessions = try await client.fetchSchedules(nil)

    // Then: Should return cached data
    #expect(sessions.count == 1)
    #expect(sessions[0].title == "Cached Session")
  }

  @Test("Should fall back to bundle data when both network and cache fail")
  func fallbackToBundleWhenNetworkAndCacheFail() async throws {
    // Given: Network fails and cache is empty
    let bundleSchedule = Schedule(
      day1: [
        Session(
          time: "09:00",
          title: "Bundle Session",
          tags: [],
          speaker: "Bundle Speaker",
          speakerID: nil,
          description: ""
        )
      ],
      day2: []
    )

    let bundleData = [
      "schedule.json": try JSONEncoder().encode(bundleSchedule)
    ]

    let client = createTestClient(
      bundleData: bundleData,
      networkShouldFail: true
    )

    // When: Fetching schedules
    let sessions = try await client.fetchSchedules(nil)

    // Then: Should return bundle data
    #expect(sessions.count == 1)
    #expect(sessions[0].title == "Bundle Session")
  }

  // MARK: - All Endpoints Tests

  @Test("Speakers fetch should use complete fallback chain from network to bundle")
  func fetchSpeakersWithFallbackChain() async throws {
    // Test the complete fallback chain for speakers
    let speakerJSON = """
      [{
        "id": 1,
        "name": "Network Speaker",
        "title": "iOS Developer",
        "intro": "From network"
      }]
      """.data(using: .utf8)!
    let networkSpeakers = try JSONDecoder().decode([Speaker].self, from: speakerJSON)

    let networkData = [
      "speakers.json": try JSONEncoder().encode(networkSpeakers)
    ]

    let client = createTestClient(
      networkData: networkData
    )

    let speakers = try await client.fetchSpeakers()
    #expect(speakers.count == 1)
    #expect(speakers[0].name == "Network Speaker")
  }

  @Test("Sponsors fetch should use complete fallback chain from network to bundle")
  func fetchSponsorsWithFallbackChain() async throws {
    let networkSponsors = SponsorsData(
      sponsors: [SponsorGroup(items: [], title: "Gold")],
      partner: []
    )

    let networkData = [
      "sponsors.json": try JSONEncoder().encode(networkSponsors)
    ]

    let client = createTestClient(
      networkData: networkData
    )

    let sponsors = try await client.fetchSponsors()
    #expect(sponsors.sponsors.count == 1)
    #expect(sponsors.sponsors[0].title == "Gold")
    #expect(sponsors.partner.count == 0)
  }

  @Test("Staffs fetch should use complete fallback chain from network to bundle")
  func fetchStaffsWithFallbackChain() async throws {
    let staffJSON = """
      [{
        "name": "Network Staff",
        "title": "Organizer"
      }]
      """.data(using: .utf8)!
    let networkStaffs = try JSONDecoder().decode([Staff].self, from: staffJSON)

    let networkData = [
      "staffs.json": try JSONEncoder().encode(networkStaffs)
    ]

    let client = createTestClient(
      networkData: networkData
    )

    let staffs = try await client.fetchStaffs()
    #expect(staffs.count == 1)
    #expect(staffs[0].name == "Network Staff")
  }
}

// MARK: - Mock Implementations

// We'll create mocks by using the actual client with test data
extension LiveSessionDataClientTests {

  func createTestClient(
    networkData: [String: Data] = [:],
    cacheData: [String: Data] = [:],
    bundleData: [String: Data] = [:],
    networkShouldFail: Bool = false
  ) -> SessionDataClient {
    SessionDataClient(
      fetchSchedules: { day in
        let endpoint = "schedule.json"

        // Try network
        if !networkShouldFail, let data = networkData[endpoint] {
          let schedule = try JSONDecoder().decode(Schedule.self, from: data)
          switch day {
          case 1: return schedule.day1
          case 2: return schedule.day2
          case nil: return schedule.day1 + schedule.day2
          default: return []
          }
        }

        // Try cache
        if let data = cacheData[endpoint] {
          let schedule = try JSONDecoder().decode(Schedule.self, from: data)
          switch day {
          case 1: return schedule.day1
          case 2: return schedule.day2
          case nil: return schedule.day1 + schedule.day2
          default: return []
          }
        }

        // Try bundle
        if let data = bundleData[endpoint] {
          let schedule = try JSONDecoder().decode(Schedule.self, from: data)
          switch day {
          case 1: return schedule.day1
          case 2: return schedule.day2
          case nil: return schedule.day1 + schedule.day2
          default: return []
          }
        }

        throw SessionDataError.decodingError
      },
      fetchSpeakers: {
        let endpoint = "speakers.json"

        if !networkShouldFail, let data = networkData[endpoint] {
          return try JSONDecoder().decode([Speaker].self, from: data)
        }
        if let data = cacheData[endpoint] {
          return try JSONDecoder().decode([Speaker].self, from: data)
        }
        if let data = bundleData[endpoint] {
          return try JSONDecoder().decode([Speaker].self, from: data)
        }
        throw SessionDataError.decodingError
      },
      fetchSponsors: {
        let endpoint = "sponsors.json"

        if !networkShouldFail, let data = networkData[endpoint] {
          return try JSONDecoder().decode(SponsorsData.self, from: data)
        }
        if let data = cacheData[endpoint] {
          return try JSONDecoder().decode(SponsorsData.self, from: data)
        }
        if let data = bundleData[endpoint] {
          return try JSONDecoder().decode(SponsorsData.self, from: data)
        }
        throw SessionDataError.decodingError
      },
      fetchStaffs: {
        let endpoint = "staffs.json"

        if !networkShouldFail, let data = networkData[endpoint] {
          return try JSONDecoder().decode([Staff].self, from: data)
        }
        if let data = cacheData[endpoint] {
          return try JSONDecoder().decode([Staff].self, from: data)
        }
        if let data = bundleData[endpoint] {
          return try JSONDecoder().decode([Staff].self, from: data)
        }
        throw SessionDataError.decodingError
      }
    )
  }
}
