import Foundation

public struct Speaker: Codable, Sendable, Equatable, Hashable {
  public var id: Int
  public var name: String
  public var title: String?
  public var intro: String
  public var photo: URL?
  public var url: URL?
  public var fb: URL?
  public var github: URL?
  public var linkedin: URL?
  public var threads: URL?
  public var x: URL?
  public var ig: URL?

  public init(
    id: Int,
    name: String,
    title: String?,
    intro: String,
    photo: URL?,
    url: URL?,
    fb: URL?,
    github: URL?,
    linkedin: URL?,
    threads: URL?,
    x: URL?,
    ig: URL?
  ) {

    self.id = id
    self.name = name
    self.title = title
    self.intro = intro
    self.photo = photo
    self.url = url
    self.fb = fb
    self.github = github
    self.linkedin = linkedin
    self.threads = threads
    self.x = x
    self.ig = ig
  }

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
