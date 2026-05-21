import Foundation

public struct News: Codable, Sendable, Equatable, Hashable {
  public var date: String
  public var title: String
  public var content: String
  public var buttons: [NewsButton]

  public init(date: String, title: String, content: String, buttons: [NewsButton]) {
    self.date = date
    self.title = title
    self.content = content
    self.buttons = buttons
  }
}

public struct NewsButton: Codable, Sendable, Equatable, Hashable {
  public var title: String
  public var url: URL

  public init(title: String, url: URL) {
    self.title = title
    self.url = url
  }
}
