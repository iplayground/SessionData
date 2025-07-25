import Foundation

public struct Schedule: Codable, Sendable, Equatable, Hashable {
  public let day1: [Session]
  public let day2: [Session]
}
