import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol NetworkFetching: Sendable {
  func fetch(endpoint: String) async throws -> Data
}

struct NetworkFetcher: NetworkFetching {
  let baseURL = "https://raw.githubusercontent.com/iplayground/SessionData/refs/heads/2026/v1/"
  private let urlSession: URLSession

  init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    self.urlSession = URLSession(configuration: configuration)
  }

  func fetch(endpoint: String) async throws -> Data {
    guard let url = URL(string: baseURL + endpoint) else {
      throw SessionDataError.invalidURL
    }

    let (data, response) = try await urlSession.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
    else {
      throw SessionDataError.networkError
    }

    return data
  }
}
