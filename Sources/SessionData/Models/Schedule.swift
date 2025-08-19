import Foundation

public struct Schedule: Codable, Sendable, Equatable, Hashable {
  public var day1: [Session]
  public var day2: [Session]

  public init(
    day1: [Session],
    day2: [Session]
  ) {
    self.day1 = day1
    self.day2 = day2
  }
}
