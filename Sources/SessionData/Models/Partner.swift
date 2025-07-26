import Foundation

public struct Partner: Codable, Sendable, Equatable, Hashable {
  public let name: String
  public let icon: URL?
  public let link: URL?

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)

    // Decode URL fields using shared extension
    icon = try container.decodeURL(forKey: .icon)
    link = try container.decodeURL(forKey: .link)
  }
}
