import Foundation

public struct Session: Codable, Sendable, Equatable, Hashable {
  public let time: String
  public let title: String
  public let tags: [String]
  public let speaker: String
  public let description: String
}
