import Foundation

public struct Session: Codable, Sendable, Equatable, Hashable {
  public var time: String
  public var title: String
  public var tags: [String]
  public var speaker: String
  public var speakerID: Speaker.ID?
  public var description: String
  public var hackMD: URL?

  public init(
    time: String,
    title: String,
    tags: [String],
    speaker: String,
    speakerID: Speaker.ID?,
    description: String,
    hackMD: URL? = nil
  ) {
    self.time = time
    self.title = title
    self.tags = tags
    self.speaker = speaker
    self.speakerID = speakerID
    self.description = description
    self.hackMD = hackMD
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    time = try container.decode(String.self, forKey: .time)
    title = try container.decode(String.self, forKey: .title)
    tags = try container.decode([String].self, forKey: .tags)
    speaker = try container.decode(String.self, forKey: .speaker)
    speakerID = try container.decodeIfPresent(Speaker.ID.self, forKey: .speakerID)
    description = try container.decode(String.self, forKey: .description)
    hackMD = try container.decodeURL(forKey: .hackMD)
  }

  private enum CodingKeys: String, CodingKey {
    case time, title, tags, speaker, speakerID, description, hackMD
  }
}
