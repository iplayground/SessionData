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
