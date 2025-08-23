import Foundation

public struct SessionDataClient: Sendable {
  public var fetchSchedules:
    @Sendable (_ day: Int?, _ dataLanguage: DataLanguage?) async throws -> [Session]
  public var fetchSpeakers: @Sendable (_ dataLanguage: DataLanguage?) async throws -> [Speaker]
  public var fetchSponsors: @Sendable () async throws -> SponsorsData
  public var fetchStaffs: @Sendable () async throws -> [Staff]
  public var fetchLinks: @Sendable () async throws -> [Link]

  public init(
    fetchSchedules: @Sendable @escaping (_ day: Int?, _ dataLanguage: DataLanguage?) async throws ->
      [Session],
    fetchSpeakers: @Sendable @escaping (_ dataLanguage: DataLanguage?) async throws -> [Speaker],
    fetchSponsors: @Sendable @escaping () async throws -> SponsorsData,
    fetchStaffs: @Sendable @escaping () async throws -> [Staff],
    fetchLinks: @Sendable @escaping () async throws -> [Link]
  ) {
    self.fetchSchedules = fetchSchedules
    self.fetchSpeakers = fetchSpeakers
    self.fetchSponsors = fetchSponsors
    self.fetchStaffs = fetchStaffs
    self.fetchLinks = fetchLinks
  }
}

// MARK: - Mock Client
extension SessionDataClient {
  public static let mock = SessionDataClient(
    fetchSchedules: { _, _ in [] },
    fetchSpeakers: { _ in [] },
    fetchSponsors: { SponsorsData(sponsors: [], partner: []) },
    fetchStaffs: { [] },
    fetchLinks: { [] }
  )
}
