import Foundation

enum SessionDataError: Error {
  case invalidURL
  case networkError
  case decodingError
}