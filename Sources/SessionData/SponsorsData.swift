import Foundation

public struct SponsorsData: Codable {
  public let sponsors: [SponsorGroup]
  public let partner: [Partner]
}
