import Foundation

public struct Partner: Codable, Sendable, Equatable, Hashable {
  public var name: String
  public var icon: URL?
  public var link: URL?

  public init(
    name: String,
    icon: URL?,
    link: URL?
  ) {
    self.name = name
    self.icon = icon
    self.link = link
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)

    // Decode URL fields using shared extension
    icon = try container.decodeURL(forKey: .icon)
    link = try container.decodeURL(forKey: .link)
  }
}
