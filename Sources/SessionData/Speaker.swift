import Foundation

public struct Speaker: Codable {
  public let id: Int
  public let name: String
  public let title: String?
  public let intro: String
  public let photo: URL?
  public let url: URL?
  public let fb: URL?
  public let github: URL?
  public let linkedin: URL?
  public let threads: URL?
  public let x: URL?
  public let ig: URL?

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    intro = try container.decode(String.self, forKey: .intro)

    // Decode all URL fields using shared extension
    photo = try container.decodeURL(forKey: .photo)
    url = try container.decodeURL(forKey: .url)
    fb = try container.decodeURL(forKey: .fb)
    github = try container.decodeURL(forKey: .github)
    linkedin = try container.decodeURL(forKey: .linkedin)
    threads = try container.decodeURL(forKey: .threads)
    x = try container.decodeURL(forKey: .x)
    ig = try container.decodeURL(forKey: .ig)
  }
}
