import Foundation
import Testing

@testable import SessionData

struct CacheManagerTests {

  @Test("Cache saves and loads data correctly")
  func testSaveAndLoadData() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    let testKey = "test.json"
    let testData = "Test cache data".data(using: .utf8)!

    // Save data
    await cacheManager.save(testData, for: testKey)

    // Load data
    let loadedData = await cacheManager.load(for: testKey)
    #expect(loadedData == testData, "Loaded data should match saved data")
  }

  @Test("Cache returns nil for non-existent key")
  func testLoadNonExistentKey() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    let nonExistentKey = "nonexistent.json"
    let loadedData = await cacheManager.load(for: nonExistentKey)
    #expect(loadedData == nil, "Should return nil for non-existent key")
  }

  @Test("Cache clears specific key correctly")
  func testClearSpecificKey() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    let testKey = "test.json"
    let testData = "Test cache data".data(using: .utf8)!

    // Save data
    await cacheManager.save(testData, for: testKey)

    // Verify data exists
    let loadedData = await cacheManager.load(for: testKey)
    #expect(loadedData != nil, "Data should exist before clearing")

    // Clear specific key
    await cacheManager.clear(for: testKey)

    // Verify data is gone
    let clearedData = await cacheManager.load(for: testKey)
    #expect(clearedData == nil, "Data should be nil after clearing")
  }

  @Test("Cache clears all data correctly")
  func testClearAllCache() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    let testData = "Test cache data".data(using: .utf8)!

    // Save multiple items
    await cacheManager.save(testData, for: "test1.json")
    await cacheManager.save(testData, for: "test2.json")
    await cacheManager.save(testData, for: "test3.json")

    // Verify all exist
    #expect(await cacheManager.load(for: "test1.json") != nil)
    #expect(await cacheManager.load(for: "test2.json") != nil)
    #expect(await cacheManager.load(for: "test3.json") != nil)

    // Clear all
    await cacheManager.clearAll()

    // Verify all are gone
    #expect(await cacheManager.load(for: "test1.json") == nil)
    #expect(await cacheManager.load(for: "test2.json") == nil)
    #expect(await cacheManager.load(for: "test3.json") == nil)
  }

  @Test("Cache overwrites files correctly")
  func testFileOverwrite() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    let testKey = "test.json"
    let originalData = "Original data".data(using: .utf8)!
    let newData = "New data".data(using: .utf8)!

    // Save original data
    await cacheManager.save(originalData, for: testKey)
    let loadedOriginal = await cacheManager.load(for: testKey)
    #expect(loadedOriginal == originalData)

    // Overwrite with new data
    await cacheManager.save(newData, for: testKey)
    let loadedNew = await cacheManager.load(for: testKey)
    #expect(loadedNew == newData, "Should load new data after overwrite")
  }

  @Test("Cache handles empty data correctly")
  func testEmptyData() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    let testKey = "empty.json"
    let emptyData = Data()

    // Save empty data
    await cacheManager.save(emptyData, for: testKey)

    // Load empty data
    let loadedData = await cacheManager.load(for: testKey)
    #expect(loadedData == emptyData, "Should handle empty data correctly")
  }

  @Test("Cache handles concurrent operations correctly")
  func testConcurrentOperations() async throws {
    let uniqueDir = "TestCache_\(UUID().uuidString)"
    let cacheManager = CacheManager(directory: uniqueDir)

    // Perform concurrent saves
    await withTaskGroup(of: Void.self) { group in
      for i in 0..<10 {
        group.addTask {
          let testData = "Test data \(i)".data(using: .utf8)!
          await cacheManager.save(testData, for: "test\(i).json")
        }
      }
    }

    // Verify all saves succeeded
    for i in 0..<10 {
      let loadedData = await cacheManager.load(for: "test\(i).json")
      let expectedData = "Test data \(i)".data(using: .utf8)!
      #expect(loadedData == expectedData, "Concurrent save \(i) should succeed")
    }
  }
}
