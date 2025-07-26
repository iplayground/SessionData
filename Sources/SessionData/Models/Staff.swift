import Foundation

public struct Staff: Codable, Sendable, Equatable, Hashable {
  public let name: String
  public let title: String?
  public let photo: URL?
  public let url: URL?

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)
    title = try container.decodeIfPresent(String.self, forKey: .title)

    // Decode URL fields using shared extension
    photo = try container.decodeURL(forKey: .photo)
    url = try container.decodeURL(forKey: .url)
  }
}
