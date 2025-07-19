import Testing
import Foundation
@testable import SessionDataValidator

@Suite("Session Data JSON Validation")
struct SessionDataValidatorTests {
  
  @Test("Speakers JSON can be decoded")
  func speakersJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "speakers", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let speakers = try SessionDataValidator.validateSpeakers(from: data)
    
    #expect(!speakers.isEmpty)
  }
  
  @Test("Schedule JSON can be decoded")
  func scheduleJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "schedule", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let schedule = try SessionDataValidator.validateSchedule(from: data)
    
    #expect(!schedule.day1.isEmpty)
    #expect(!schedule.day2.isEmpty)
  }
  
  @Test("Sponsors JSON can be decoded")
  func sponsorsJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "sponsors", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let sponsorsData = try SessionDataValidator.validateSponsors(from: data)
    
    #expect(!sponsorsData.sponsors.isEmpty)
    #expect(!sponsorsData.partner.isEmpty)
  }
  
  @Test("Staffs JSON can be decoded")
  func staffsJSONDecoding() throws {
    let jsonURL = Bundle.module.url(forResource: "staffs", withExtension: "json")!
    let data = try Data(contentsOf: jsonURL)
    let staffs = try SessionDataValidator.validateStaffs(from: data)
    
    #expect(!staffs.isEmpty)
  }
}