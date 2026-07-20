import Foundation
import Testing

@testable import SessionData

@Suite("Schedule")
struct ScheduleTests {

  @Test("Workshop arrays decode from snake case keys")
  func workshopArraysDecodeFromSnakeCaseKeys() throws {
    let json = """
      {
        "day1": [],
        "day2": [],
        "workshop_day1": [
          {
            "time": "10:00",
            "title": "Day 1 Workshop",
            "tags": [],
            "speaker": "Speaker 1",
            "description": "Day 1"
          }
        ],
        "workshop_day2": [
          {
            "time": "11:00",
            "title": "Day 2 Workshop",
            "tags": [],
            "speaker": "Speaker 2",
            "description": "Day 2"
          }
        ]
      }
      """

    let schedule = try JSONDecoder().decode(Schedule.self, from: Data(json.utf8))

    #expect(schedule.workshopDay1.map(\.title) == ["Day 1 Workshop"])
    #expect(schedule.workshopDay2.map(\.title) == ["Day 2 Workshop"])
  }

  @Test("Missing workshop keys decode as empty arrays")
  func missingWorkshopKeysDecodeAsEmptyArrays() throws {
    let json = """
      {
        "day1": [],
        "day2": []
      }
      """

    let schedule = try JSONDecoder().decode(Schedule.self, from: Data(json.utf8))

    #expect(schedule.workshopDay1.isEmpty)
    #expect(schedule.workshopDay2.isEmpty)
  }

  @Test("Workshop helpers preserve day order and all entries")
  func workshopHelpersPreserveDayOrderAndAllEntries() {
    let day1Workshop = makeSession(title: "Day 1 Workshop")
    let day1Break = makeSession(title: "Day 1 Break")
    let day2Workshop = makeSession(title: "Day 2 Workshop")
    let day2Break = makeSession(title: "Day 2 Break")
    let schedule = Schedule(
      day1: [],
      day2: [],
      workshopDay1: [day1Workshop, day1Break],
      workshopDay2: [day2Workshop, day2Break]
    )

    #expect(schedule.allWorkshops == [day1Workshop, day1Break, day2Workshop, day2Break])
    #expect(schedule.workshops(day: 1) == [day1Workshop, day1Break])
    #expect(schedule.workshops(day: 2) == [day2Workshop, day2Break])
    #expect(schedule.workshops(day: 3).isEmpty)
  }

  @Test("Main schedule helpers exclude workshops")
  func mainScheduleHelpersExcludeWorkshops() {
    let day1Session = makeSession(title: "Day 1 Session")
    let day2Session = makeSession(title: "Day 2 Session")
    let schedule = Schedule(
      day1: [day1Session],
      day2: [day2Session],
      workshopDay1: [makeSession(title: "Day 1 Workshop")],
      workshopDay2: [makeSession(title: "Day 2 Workshop")]
    )

    #expect(schedule.allSessions == [day1Session, day2Session])
    #expect(schedule.sessions(day: 1) == [day1Session])
    #expect(schedule.sessions(day: 2) == [day2Session])
    #expect(schedule.sessions(day: 3).isEmpty)
  }

  private func makeSession(title: String) -> Session {
    Session(
      time: "10:00",
      title: title,
      tags: [],
      speaker: "Speaker",
      speakerID: nil,
      description: "Description"
    )
  }
}
