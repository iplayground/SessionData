import Foundation
import Testing

@testable import SessionData

@Suite("Session Data JSON Validation")
struct SessionDataTests {

  @Test("Speakers JSON can be decoded")
  func speakersJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "speakers", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let speakers = try JSONDecoder().decode([Speaker].self, from: data)

    #expect(!speakers.isEmpty)

    // Ensure speakers have unique id
    let ids = speakers.map { $0.id }
    let uniqueIDs = Set(ids)
    #expect(ids.count == uniqueIDs.count, "Speakers should have unique ids")
  }

  @Test("Schedule JSON can be decoded")
  func scheduleJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "schedule", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let schedule = try JSONDecoder().decode(Schedule.self, from: data)

    #expect(!schedule.day1.isEmpty)
    #expect(!schedule.day2.isEmpty)
  }

  @Test("Sponsors JSON can be decoded")
  func sponsorsJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "sponsors", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let sponsorsData = try JSONDecoder().decode(SponsorsData.self, from: data)

    #expect(!sponsorsData.sponsors.isEmpty)
    #expect(!sponsorsData.partner.isEmpty)
  }

  @Test("Staffs JSON can be decoded")
  func staffsJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "staffs", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let staffs = try JSONDecoder().decode([Staff].self, from: data)

    #expect(!staffs.isEmpty)
  }
}
