import Foundation

public struct Staff: Codable, Sendable, Equatable, Hashable {
  public var name: String
  public var title: String?
  public var photo: URL?
  public var url: URL?

  public init(
    name: String,
    title: String?,
    photo: URL?,
    url: URL?
  ) {
    self.name = name
    self.title = title
    self.photo = photo
    self.url = url
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    name = try container.decode(String.self, forKey: .name)
    title = try container.decodeIfPresent(String.self, forKey: .title)

    // Decode URL fields using shared extension
    photo = try container.decodeURL(forKey: .photo)
    url = try container.decodeURL(forKey: .url)
  }
}
