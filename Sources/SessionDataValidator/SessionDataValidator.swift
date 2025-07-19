import Foundation

public struct SessionDataValidator {
  
  public static func validateSpeakers(from data: Data) throws -> [Speaker] {
    let decoder = JSONDecoder()
    return try decoder.decode([Speaker].self, from: data)
  }
  
  public static func validateSchedule(from data: Data) throws -> Schedule {
    let decoder = JSONDecoder()
    return try decoder.decode(Schedule.self, from: data)
  }
  
  public static func validateSponsors(from data: Data) throws -> SponsorsData {
    let decoder = JSONDecoder()
    return try decoder.decode(SponsorsData.self, from: data)
  }
  
  public static func validateStaffs(from data: Data) throws -> [Staff] {
    let decoder = JSONDecoder()
    return try decoder.decode([Staff].self, from: data)
  }
}