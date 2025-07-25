import Foundation

public struct SponsorGroup: Codable, Sendable, Equatable, Hashable {
  public let items: [SponsorItem]
  public let title: String
}
