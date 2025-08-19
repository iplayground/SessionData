import Foundation

public struct SponsorGroup: Codable, Sendable, Equatable, Hashable {
  public var items: [SponsorItem]
  public var title: String

  public init(
    items: [SponsorItem],
    title: String
  ) {
    self.items = items
    self.title = title
  }
}
