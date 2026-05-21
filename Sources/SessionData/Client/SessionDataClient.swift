import Foundation

public struct SessionDataClient: Sendable {
  public var fetchSchedules:
    @Sendable (_ day: Int?, _ dataLanguage: DataLanguage, _ strategy: FetchStrategy) async throws ->
      [Session]
  public var fetchSpeakers:
    @Sendable (_ dataLanguage: DataLanguage, _ strategy: FetchStrategy) async throws -> [Speaker]
  public var fetchSponsors: @Sendable (_ strategy: FetchStrategy) async throws -> SponsorsData
  public var fetchStaffs: @Sendable (_ strategy: FetchStrategy) async throws -> [Staff]
  public var fetchLinks: @Sendable (_ strategy: FetchStrategy) async throws -> [Link]
  public var fetchNews:
    @Sendable (_ dataLanguage: DataLanguage, _ strategy: FetchStrategy) async throws -> [News]

  public init(
    fetchSchedules: @Sendable @escaping (
      _ day: Int?, _ dataLanguage: DataLanguage, _ strategy: FetchStrategy
    ) async throws ->
      [Session],
    fetchSpeakers: @Sendable @escaping (_ dataLanguage: DataLanguage, _ strategy: FetchStrategy)
      async throws -> [Speaker],
    fetchSponsors: @Sendable @escaping (_ strategy: FetchStrategy) async throws -> SponsorsData,
    fetchStaffs: @Sendable @escaping (_ strategy: FetchStrategy) async throws -> [Staff],
    fetchLinks: @Sendable @escaping (_ strategy: FetchStrategy) async throws -> [Link],
    fetchNews: @Sendable @escaping (_ dataLanguage: DataLanguage, _ strategy: FetchStrategy)
      async throws -> [News] = { _, _ in [] }
  ) {
    self.fetchSchedules = fetchSchedules
    self.fetchSpeakers = fetchSpeakers
    self.fetchSponsors = fetchSponsors
    self.fetchStaffs = fetchStaffs
    self.fetchLinks = fetchLinks
    self.fetchNews = fetchNews
  }
}

// MARK: - Convenience Methods with Default Strategy
extension SessionDataClient {
  public func fetchSchedules(
    day: Int? = nil, dataLanguage: DataLanguage, strategy: FetchStrategy = .remote
  ) async throws -> [Session] {
    return try await fetchSchedules(day, dataLanguage, strategy)
  }

  public func fetchSpeakers(dataLanguage: DataLanguage, strategy: FetchStrategy = .remote)
    async throws -> [Speaker]
  {
    return try await fetchSpeakers(dataLanguage, strategy)
  }

  public func fetchSponsors(strategy: FetchStrategy = .remote) async throws -> SponsorsData {
    return try await fetchSponsors(strategy)
  }

  public func fetchStaffs(strategy: FetchStrategy = .remote) async throws -> [Staff] {
    return try await fetchStaffs(strategy)
  }

  public func fetchLinks(strategy: FetchStrategy = .remote) async throws -> [Link] {
    return try await fetchLinks(strategy)
  }

  public func fetchNews(dataLanguage: DataLanguage, strategy: FetchStrategy = .remote)
    async throws -> [News]
  {
    return try await fetchNews(dataLanguage, strategy)
  }
}
