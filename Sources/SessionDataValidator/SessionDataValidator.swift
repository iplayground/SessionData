import Foundation

public struct SessionDataValidator {
  
  private static let sharedDecoder = JSONDecoder()
  
  public static func validateSpeakers(from data: Data) throws -> [Speaker] {
    return try sharedDecoder.decode([Speaker].self, from: data)
  }
  
  public static func validateSchedule(from data: Data) throws -> Schedule {
    return try sharedDecoder.decode(Schedule.self, from: data)
  }
  
  public static func validateSponsors(from data: Data) throws -> SponsorsData {
    return try sharedDecoder.decode(SponsorsData.self, from: data)
  }
  
  public static func validateStaffs(from data: Data) throws -> [Staff] {
    return try sharedDecoder.decode([Staff].self, from: data)
  }
}