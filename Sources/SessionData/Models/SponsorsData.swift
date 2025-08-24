import Foundation

public struct SponsorsData: Codable, Sendable, Equatable, Hashable {
  public var sponsors: [SponsorGroup]
  public var personal: [PersonalSponsor]
  public var partner: [Partner]

  public init(sponsors: [SponsorGroup], personal: [PersonalSponsor], partner: [Partner]) {
    self.sponsors = sponsors
    self.personal = personal
    self.partner = partner
  }
}
