import Foundation

public struct SessionDataClient: Sendable {
  public var fetchSchedules: @Sendable (_ day: Int?) async throws -> [Session]
  public var fetchSpeakers: @Sendable () async throws -> [Speaker]
  public var fetchSponsors: @Sendable () async throws -> SponsorsData
  public var fetchStaffs: @Sendable () async throws -> [Staff]

  public init(
    fetchSchedules: @Sendable @escaping (_ day: Int?) async throws -> [Session],
    fetchSpeakers: @Sendable @escaping () async throws -> [Speaker],
    fetchSponsors: @Sendable @escaping () async throws -> SponsorsData,
    fetchStaffs: @Sendable @escaping () async throws -> [Staff]
  ) {
    self.fetchSchedules = fetchSchedules
    self.fetchSpeakers = fetchSpeakers
    self.fetchSponsors = fetchSponsors
    self.fetchStaffs = fetchStaffs
  }
}

// MARK: - Mock Client
extension SessionDataClient {
  public static let mock = SessionDataClient(
    fetchSchedules: { _ in [] },
    fetchSpeakers: { [] },
    fetchSponsors: { SponsorsData(sponsors: [], partner: []) },
    fetchStaffs: { [] }
  )
}
