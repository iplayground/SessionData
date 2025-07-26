import Foundation

public struct SponsorItem: Codable, Sendable, Equatable, Hashable {
  public let name: String
  public let picture: URL?
  public let link: URL?

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)

    // Decode URL fields using shared extension
    picture = try container.decodeURL(forKey: .picture)
    link = try container.decodeURL(forKey: .link)
  }
}
