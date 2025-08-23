import Foundation

public enum FetchStrategy: Sendable {
  case remote
  case cacheFirst
  case localOnly
}
