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

  @Test("Schedule JSON can be decoded", arguments: DataLanguage.allCases)
  func scheduleJSONDecoding(dataLanguage: DataLanguage) throws {
    let jsonURL = Bundle.module.url(
      forResource: "schedule\(dataLanguage.fileNameSuffix)", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let schedule = try JSONDecoder().decode(Schedule.self, from: data)

    #expect(!schedule.day1.isEmpty)
    #expect(!schedule.day2.isEmpty)
  }

  @Test("All session speakerIDs can be found in speakers", arguments: DataLanguage.allCases)
  func sessionSpeakerIDsExistInSpeakers(dataLanguage: DataLanguage) throws {
    // Load speakers
    let speakersURL = Bundle.module.url(forResource: "speakers", withExtension: "json")!
    let speakersData = try Data(contentsOf: speakersURL)
    let speakers = try JSONDecoder().decode([Speaker].self, from: speakersData)
    let speakerIDs = Set(speakers.map { $0.id })

    // Load schedule
    let scheduleURL = Bundle.module.url(
      forResource: "schedule\(dataLanguage.fileNameSuffix)", withExtension: "json")!
    let scheduleData = try Data(contentsOf: scheduleURL)
    let schedule = try JSONDecoder().decode(Schedule.self, from: scheduleData)

    // Gather all sessions from both days
    let allSessions = schedule.day1 + schedule.day2

    // Check that every session with a speakerID has that ID in speakers
    for session in allSessions {
      if let speakerID = session.speakerID {
        #expect(
          speakerIDs.contains(speakerID),
          "Session '\(session.title)' has unknown speakerID: \(speakerID)")
      }
    }
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
