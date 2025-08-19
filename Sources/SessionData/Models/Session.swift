import Foundation

public struct Session: Codable, Sendable, Equatable, Hashable {
  public var time: String
  public var title: String
  public var tags: [String]
  public var speaker: String
  public var description: String

  public init(
    time: String,
    title: String,
    tags: [String],
    speaker: String,
    description: String
  ) {
    self.time = time
    self.title = title
    self.tags = tags
    self.speaker = speaker
    self.description = description
  }
}
