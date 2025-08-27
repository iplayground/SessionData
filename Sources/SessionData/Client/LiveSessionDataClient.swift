import Foundation

struct LiveSessionDataClient: Sendable {
  private let networkFetcher: any NetworkFetching
  private let cacheManager: CacheManager
  private let bundleLoader: BundleLoader

  init() {
    self.networkFetcher = NetworkFetcher()
    self.cacheManager = CacheManager(directory: "SessionDataCache")
    self.bundleLoader = BundleLoader()
  }

  // For testing
  init(networkFetcher: any NetworkFetching, cacheManager: CacheManager, bundleLoader: BundleLoader)
  {
    self.networkFetcher = networkFetcher
    self.cacheManager = cacheManager
    self.bundleLoader = bundleLoader
  }
}

// MARK: - SessionDataClient Extension

extension SessionDataClient {
  public static let live: SessionDataClient = {
    let client = LiveSessionDataClient()
    return SessionDataClient(
      fetchSchedules: { day, dataLanguage, strategy in
        try await client.fetchSchedules(day: day, dataLanguage: dataLanguage, strategy: strategy)
      },
      fetchSpeakers: { dataLanguage, strategy in
        try await client.fetchSpeakers(dataLanguage: dataLanguage, strategy: strategy)
      },
      fetchSponsors: { strategy in
        try await client.fetchSponsors(strategy: strategy)
      },
      fetchStaffs: { strategy in
        try await client.fetchStaffs(strategy: strategy)
      },
      fetchLinks: { strategy in
        try await client.fetchLinks(strategy: strategy)
      }
    )
  }()
}

// MARK: - Fetch Implementation

extension LiveSessionDataClient {
  func fetchSchedules(day: Int?, dataLanguage: DataLanguage, strategy: FetchStrategy) async throws
    -> [Session]
  {
    let fileName = dataLanguage.scheduleFileName
    let data = try await fetchData(endpoint: "\(fileName).json", strategy: strategy)
    let schedule = try JSONDecoder().decode(Schedule.self, from: data)

    switch day {
    case 1:
      return schedule.day1
    case 2:
      return schedule.day2
    case nil:
      return schedule.day1 + schedule.day2
    default:
      return []
    }
  }

  func fetchSpeakers(dataLanguage: DataLanguage, strategy: FetchStrategy) async throws -> [Speaker]
  {
    let fileName = dataLanguage.speakersFileName
    let data = try await fetchData(endpoint: "\(fileName).json", strategy: strategy)
    return try JSONDecoder().decode([Speaker].self, from: data)
  }

  func fetchSponsors(strategy: FetchStrategy) async throws -> SponsorsData {
    let data = try await fetchData(endpoint: "sponsors.json", strategy: strategy)
    return try JSONDecoder().decode(SponsorsData.self, from: data)
  }

  func fetchStaffs(strategy: FetchStrategy) async throws -> [Staff] {
    let data = try await fetchData(endpoint: "staffs.json", strategy: strategy)
    return try JSONDecoder().decode([Staff].self, from: data)
  }

  func fetchLinks(strategy: FetchStrategy) async throws -> [Link] {
    let data = try await fetchData(endpoint: "links.json", strategy: strategy)
    return try JSONDecoder().decode([Link].self, from: data)
  }

  private func fetchData(endpoint: String, strategy: FetchStrategy) async throws -> Data {
    switch strategy {
    case .remote:
      return try await fetchRemote(endpoint: endpoint)
    case .cacheFirst:
      return try await fetchCacheFirst(endpoint: endpoint)
    case .localOnly:
      return try await fetchLocal(endpoint: endpoint)
    }
  }

  private func fetchRemote(endpoint: String) async throws -> Data {
    // Try network first
    do {
      let data = try await networkFetcher.fetch(endpoint: endpoint)
      await cacheManager.save(data, for: endpoint)
      return data
    } catch {
      // Try cache if network fails
      if let cachedData = await cacheManager.load(for: endpoint) {
        return cachedData
      }

      // Fall back to bundle
      return try bundleLoader.load(file: endpoint)
    }
  }

  private func fetchCacheFirst(endpoint: String) async throws -> Data {
    if let cachedData = await cacheManager.load(for: endpoint) {
      return cachedData
    }

    return try bundleLoader.load(file: endpoint)
  }

  private func fetchLocal(endpoint: String) async throws -> Data {
    return try bundleLoader.load(file: endpoint)
  }
}
