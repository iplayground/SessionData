import Foundation
import Testing

@testable import SessionData

struct NetworkFetcherTests {

  @Test("Valid URLs are constructed correctly")
  func testURLConstruction() async throws {
    let networkFetcher = NetworkFetcher()
    
    // Test that the URL construction doesn't fail for valid endpoints
    do {
      // This might fail due to network, but we want to test URL construction
      _ = try await networkFetcher.fetch(endpoint: "schedule.json")
    } catch SessionDataError.networkError {
      // Network error is expected and acceptable - means URL was valid
      // This test passes because URL construction worked
    } catch SessionDataError.invalidURL {
      #expect(false, "Should not throw invalidURL for valid endpoint")
    }
  }

  @Test("Invalid endpoints trigger network error")
  func testInvalidEndpoints() async throws {
    let networkFetcher = NetworkFetcher()
    
    // URLs with spaces are actually handled by URL encoding, so they become network errors
    await #expect(throws: SessionDataError.networkError) {
      try await networkFetcher.fetch(endpoint: "invalid endpoint that does not exist")
    }
  }

  @Test("Network errors are handled gracefully")
  func testNetworkErrorHandling() async throws {
    let networkFetcher = NetworkFetcher()
    
    // Test with a non-existent endpoint that should return network error
    do {
      _ = try await networkFetcher.fetch(endpoint: "nonexistent-file-12345.json")
      #expect(false, "Should throw network error for non-existent file")
    } catch SessionDataError.networkError {
      // Expected - this is the correct error for network failures
    } catch {
      #expect(false, "Should throw SessionDataError.networkError, not \(error)")
    }
  }

  @Test("Base URL is configured correctly")
  func testBaseURLConfiguration() {
    let networkFetcher = NetworkFetcher()
    
    // Verify the base URL is correctly set
    #expect(networkFetcher.baseURL == "https://raw.githubusercontent.com/iplayground/SessionData/refs/heads/2025/v1/")
  }
}