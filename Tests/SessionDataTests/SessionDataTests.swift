import Foundation
import Testing

@testable import SessionData

@Suite("Session Data JSON Validation")
struct SessionDataTests {

  @Test("Speakers JSON can be decoded", arguments: DataLanguage.allCases)
  func speakersJSONDecoding(dataLanguage: DataLanguage) throws {
    let jsonURL = Bundle.module.url(
      forResource: "speakers\(dataLanguage.fileNameSuffix)", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let speakers = try JSONDecoder().decode([Speaker].self, from: data)

    #expect(!speakers.isEmpty)

    // Ensure speakers have unique id
    let ids = speakers.map { $0.id }
    let uniqueIDs = Set(ids)
    #expect(ids.count == uniqueIDs.count, "Speakers should have unique ids")
  }

  @Test("Translated speakers JSON files match source of truth for non-translatable fields")
  func speakersJSONPropertiesConsistency() throws {
    let sourceOfTruthSpeakers = try loadSpeakers(for: .traditionalChinese)
    let sourceByID = Dictionary(uniqueKeysWithValues: sourceOfTruthSpeakers.map { ($0.id, $0) })

    let translatedLanguages = DataLanguage.allCases.filter { $0 != .traditionalChinese }

    for language in translatedLanguages {
      let translatedSpeakers = try loadSpeakers(for: language)
      let fileName = "\(language.speakersFileName).json"

      for translatedSpeaker in translatedSpeakers {
        guard let sourceSpeaker = sourceByID[translatedSpeaker.id] else {
          Issue.record(
            "Speaker ID \(translatedSpeaker.id) exists in \(fileName) but not in source speakers.json"
          )
          continue
        }

        validateSpeakerFieldsMatch(
          source: sourceSpeaker,
          translated: translatedSpeaker,
          translatedFileName: fileName
        )
      }

      let translatedIDs = Set(translatedSpeakers.map(\.id))
      let sourceIDs = Set(sourceOfTruthSpeakers.map(\.id))
      let missingInTranslation = sourceIDs.subtracting(translatedIDs)

      for missingID in missingInTranslation {
        Issue.record(
          "Speaker ID \(missingID) exists in source speakers.json but missing in \(fileName)")
      }
    }
  }

  private func loadSpeakers(for language: DataLanguage) throws -> [Speaker] {
    let url = Bundle.module.url(
      forResource: language.speakersFileName,
      withExtension: "json"
    )!
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([Speaker].self, from: data)
  }

  private func validateSpeakerFieldsMatch(
    source: Speaker,
    translated: Speaker,
    translatedFileName: String
  ) {
    let urlFields: [(keyPath: KeyPath<Speaker, URL?>, name: String)] = [
      (\.photo, "photo"),
      (\.url, "personal"),
      (\.fb, "Facebook"),
      (\.github, "GitHub"),
      (\.linkedin, "LinkedIn"),
      (\.threads, "Threads"),
      (\.x, "X"),
      (\.ig, "Instagram"),
    ]

    for (keyPath, fieldName) in urlFields {
      let sourceValue = source[keyPath: keyPath]
      let translatedValue = translated[keyPath: keyPath]
      #expect(
        sourceValue == translatedValue,
        "Fix \(translatedFileName): Speaker \(source.id) \(fieldName) URL should be '\(sourceValue?.absoluteString ?? "nil")' but is '\(translatedValue?.absoluteString ?? "nil")'"
      )
    }
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
    let speakersURL = Bundle.module.url(
      forResource: "speakers\(dataLanguage.fileNameSuffix)", withExtension: "json")!
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

  @Test("Translated schedule JSON files match source of truth for speakerID and time")
  func schedulesJSONPropertiesConsistency() throws {
    let sourceSchedule = try loadSchedule(for: .traditionalChinese)

    let translatedLanguages = DataLanguage.allCases.filter { $0 != .traditionalChinese }

    for language in translatedLanguages {
      let translatedSchedule = try loadSchedule(for: language)
      let fileName = "\(language.scheduleFileName).json"

      validateScheduleConsistency(
        source: sourceSchedule,
        translated: translatedSchedule,
        translatedFileName: fileName
      )
    }
  }

  private func loadSchedule(for language: DataLanguage) throws -> Schedule {
    let url = Bundle.module.url(
      forResource: language.scheduleFileName,
      withExtension: "json"
    )!
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(Schedule.self, from: data)
  }

  private func validateScheduleConsistency(
    source: Schedule,
    translated: Schedule,
    translatedFileName: String
  ) {
    #expect(
      source.day1.count == translated.day1.count,
      "Fix \(translatedFileName): Day1 should have \(source.day1.count) sessions but has \(translated.day1.count)"
    )
    #expect(
      source.day2.count == translated.day2.count,
      "Fix \(translatedFileName): Day2 should have \(source.day2.count) sessions but has \(translated.day2.count)"
    )

    validateSessionConsistency(
      source.day1, translated.day1, day: 1, translatedFileName: translatedFileName)
    validateSessionConsistency(
      source.day2, translated.day2, day: 2, translatedFileName: translatedFileName)
  }

  private func validateSessionConsistency(
    _ sourceSessions: [Session],
    _ translatedSessions: [Session],
    day: Int,
    translatedFileName: String
  ) {
    let fieldsToValidate:
      [(keyPath: PartialKeyPath<Session>, name: String, formatter: (Any?) -> String)] = [
        (\.speakerID, "speakerID", { String(describing: $0) }),
        (\.time, "time", { "'\($0 as? String ?? "nil")'" }),
        (
          \.hackMD, "hackMD",
          {
            if let url = $0 as? URL? {
              return "'\(url?.absoluteString ?? "nil")'"
            } else {
              return "'nil'"
            }
          }
        ),
      ]

    for (sessionIndex, (sourceSession, translatedSession)) in zip(
      sourceSessions, translatedSessions
    ).enumerated() {
      for (keyPath, fieldName, formatter) in fieldsToValidate {
        let sourceValue = sourceSession[keyPath: keyPath]
        let translatedValue = translatedSession[keyPath: keyPath]
        #expect(
          areEqual(sourceValue, translatedValue),
          "Fix \(translatedFileName): Day\(day) Session\(sessionIndex) \(fieldName) should be \(formatter(sourceValue)) but is \(formatter(translatedValue))"
        )
      }
    }
  }

  private func areEqual(_ lhs: Any?, _ rhs: Any?) -> Bool {
    switch (lhs, rhs) {
    case let (l as Speaker.ID?, r as Speaker.ID?): return l == r
    case let (l as String, r as String): return l == r
    case let (l as URL?, r as URL?): return l == r
    default: return false
    }
  }

  @Test("Sponsors JSON can be decoded")
  func sponsorsJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "sponsors", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let sponsorsData = try JSONDecoder().decode(SponsorsData.self, from: data)

    #expect(
      !sponsorsData.sponsors.isEmpty || !sponsorsData.personal.isEmpty
        || !sponsorsData.partner.isEmpty
    )

    // Verify personal sponsors have required name field
    for personal in sponsorsData.personal {
      #expect(!personal.name.isEmpty, "Personal sponsor name should not be empty")
    }
  }

  @Test("Staffs JSON can be decoded")
  func staffsJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "staffs", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let staffs = try JSONDecoder().decode([Staff].self, from: data)

    #expect(!staffs.isEmpty)
  }

  @Test("Links JSON can be decoded")
  func linksJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "links", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let links = try JSONDecoder().decode([Link].self, from: data)

    #expect(!links.isEmpty)
  }
}
