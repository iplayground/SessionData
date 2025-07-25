import Foundation

public enum SessionDataError: Error, Sendable {
  case invalidURL
  case networkError
  case decodingError
}
