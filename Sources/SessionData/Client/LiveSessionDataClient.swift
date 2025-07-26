import Foundation

public struct LiveSessionDataClient {
  private let networkFetcher: any NetworkFetching
  private let cacheManager: CacheManager
  private let bundleLoader: BundleLoader

  public init() {
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
  public static let live = SessionDataClient(
    fetchSchedules: { day in
      let client = LiveSessionDataClient()
      return try await client.fetchSchedules(day: day)
    },
    fetchSpeakers: {
      let client = LiveSessionDataClient()
      return try await client.fetchSpeakers()
    },
    fetchSponsors: {
      let client = LiveSessionDataClient()
      return try await client.fetchSponsors()
    },
    fetchStaffs: {
      let client = LiveSessionDataClient()
      return try await client.fetchStaffs()
    }
  )
}

// MARK: - Fetch Implementation

extension LiveSessionDataClient {
  func fetchSchedules(day: Int?) async throws -> [Session] {
    let data = try await fetchData(endpoint: "schedule.json")
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

  func fetchSpeakers() async throws -> [Speaker] {
    let data = try await fetchData(endpoint: "speakers.json")
    return try JSONDecoder().decode([Speaker].self, from: data)
  }

  func fetchSponsors() async throws -> SponsorsData {
    let data = try await fetchData(endpoint: "sponsors.json")
    return try JSONDecoder().decode(SponsorsData.self, from: data)
  }

  func fetchStaffs() async throws -> [Staff] {
    let data = try await fetchData(endpoint: "staffs.json")
    return try JSONDecoder().decode([Staff].self, from: data)
  }

  private func fetchData(endpoint: String) async throws -> Data {
    // Try network first
    do {
      let data = try await networkFetcher.fetch(endpoint: endpoint)
      // Save to cache on success
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
}
