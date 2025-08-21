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

  @Test("Speakers JSON files have the same properties except name, title, and intro")
  func speakersJSONPropertiesConsistency() throws {
    // 讀取所有語言的 speakers 檔案，依 id 分組，檢查同 id 的 speaker 除了 name 與 title 外其他欄位都相同
    let allSpeakersByLanguage: [[Speaker]] = try DataLanguage.allCases.map { lang in
      let url = Bundle.module.url(
        forResource: "speakers\(lang.fileNameSuffix)", withExtension: "json")!
      let data = try Data(contentsOf: url)
      return try JSONDecoder().decode([Speaker].self, from: data)
    }

    // 建立 id -> [Speaker] 的對照表
    var speakersByID: [Int: [Speaker]] = [:]
    for speakers in allSpeakersByLanguage {
      for speaker in speakers {
        speakersByID[speaker.id, default: []].append(speaker)
      }
    }

    // 檢查每個 id 的 speakers，除了 name 與 title 外其他欄位都要相同
    for (id, speakers) in speakersByID {
      guard let first = speakers.first else { continue }
      for other in speakers.dropFirst() {
        // 比較除了 name 與 title 以外的欄位
        let firstComparable = Speaker(
          id: first.id,
          name: "",  // ignore
          title: nil,  // ignore
          intro: "",  // ignore
          photo: first.photo,
          url: first.url,
          fb: first.fb,
          github: first.github,
          linkedin: first.linkedin,
          threads: first.threads,
          x: first.x,
          ig: first.ig
        )
        let otherComparable = Speaker(
          id: other.id,
          name: "",  // ignore
          title: nil,  // ignore
          intro: "",  // ignore
          photo: other.photo,
          url: other.url,
          fb: other.fb,
          github: other.github,
          linkedin: other.linkedin,
          threads: other.threads,
          x: other.x,
          ig: other.ig
        )
        #expect(
          firstComparable == otherComparable,
          "Speaker with id \(id) has mismatched properties (except name/title) between languages"
        )
      }
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
