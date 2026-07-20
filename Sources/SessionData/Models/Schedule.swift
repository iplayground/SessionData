import Foundation

public struct Schedule: Codable, Sendable, Equatable, Hashable {
  public var day1: [Session]
  public var day2: [Session]
  public var workshopDay1: [Session]
  public var workshopDay2: [Session]

  public init(
    day1: [Session],
    day2: [Session],
    workshopDay1: [Session] = [],
    workshopDay2: [Session] = []
  ) {
    self.day1 = day1
    self.day2 = day2
    self.workshopDay1 = workshopDay1
    self.workshopDay2 = workshopDay2
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    day1 = try container.decode([Session].self, forKey: .day1)
    day2 = try container.decode([Session].self, forKey: .day2)
    workshopDay1 = try container.decodeIfPresent([Session].self, forKey: .workshopDay1) ?? []
    workshopDay2 = try container.decodeIfPresent([Session].self, forKey: .workshopDay2) ?? []
  }

  private enum CodingKeys: String, CodingKey {
    case day1, day2
    case workshopDay1 = "workshop_day1"
    case workshopDay2 = "workshop_day2"
  }
}

extension Schedule {
  public var allSessions: [Session] {
    day1 + day2
  }

  public func sessions(day: Int) -> [Session] {
    switch day {
    case 1:
      return day1
    case 2:
      return day2
    default:
      return []
    }
  }

  public var allWorkshops: [Session] {
    workshopDay1 + workshopDay2
  }

  public func workshops(day: Int) -> [Session] {
    switch day {
    case 1:
      return workshopDay1
    case 2:
      return workshopDay2
    default:
      return []
    }
  }
}
