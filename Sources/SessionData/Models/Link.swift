import Foundation

public enum LinkType: String, Codable, CaseIterable {
  case primary = "primary"
  case social = "social"
  case appInfo = "appInfo"
}

public struct Link: Codable, Equatable, Identifiable {
  public var id: String
  public var title: String
  public var url: URL
  /// SF Symbols name
  public var icon: String?
  public var type: LinkType

  public init(id: String, title: String, url: URL, icon: String? = nil, type: LinkType) {
    self.id = id
    self.title = title
    self.url = url
    self.icon = icon
    self.type = type
  }
}
