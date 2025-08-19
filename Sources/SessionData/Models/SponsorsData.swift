import Foundation

public struct SponsorsData: Codable, Sendable, Equatable, Hashable {
  public var sponsors: [SponsorGroup]
  public var partner: [Partner]

  public init(sponsors: [SponsorGroup], partner: [Partner]) {
    self.sponsors = sponsors
    self.partner = partner
  }
}
