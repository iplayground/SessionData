import Foundation

extension KeyedDecodingContainer {
  func decodeURL(forKey key: Key) throws -> URL? {
    guard let urlString = try decodeIfPresent(String.self, forKey: key),
      !urlString.isEmpty
    else {
      return nil
    }
    return URL(string: urlString)
  }
}

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

public struct Session: Codable {
  public let time: String
  public let title: String
  public let tags: [String]
  public let speaker: String
  public let description: String
}

public struct Schedule: Codable {
  public let day1: [Session]
  public let day2: [Session]
}

public struct SponsorItem: Codable {
  public let name: String
  public let picture: String
  public let link: String
}

public struct SponsorGroup: Codable {
  public let items: [SponsorItem]
  public let title: String
}

public struct Partner: Codable {
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

public struct SponsorsData: Codable {
  public let sponsors: [SponsorGroup]
  public let partner: [Partner]
}

public struct Staff: Codable {
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
