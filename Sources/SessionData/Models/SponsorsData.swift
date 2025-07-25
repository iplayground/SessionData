import Foundation

public struct SponsorsData: Codable, Sendable, Equatable, Hashable {
  public let sponsors: [SponsorGroup]
  public let partner: [Partner]
}
