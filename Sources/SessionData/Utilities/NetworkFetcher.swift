import Foundation

protocol NetworkFetching {
  func fetch(endpoint: String) async throws -> Data
}

struct NetworkFetcher: NetworkFetching {
  let baseURL = "https://raw.githubusercontent.com/iplayground/SessionData/refs/heads/2025/v1/"

  func fetch(endpoint: String) async throws -> Data {
    guard let url = URL(string: baseURL + endpoint) else {
      throw SessionDataError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
    else {
      throw SessionDataError.networkError
    }

    return data
  }
}
