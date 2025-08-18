import Foundation

public struct SponsorItem: Codable, Sendable, Equatable, Hashable {
  public var name: String
  public var picture: URL?
  public var link: URL?

  public init(
    name: String,
    picture: URL?,
    link: URL?
  ) {
    self.name = name
    self.picture = picture
    self.link = link
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)

    // Decode URL fields using shared extension
    picture = try container.decodeURL(forKey: .picture)
    link = try container.decodeURL(forKey: .link)
  }
}
