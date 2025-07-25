import Foundation
import OSLog

actor CacheManager {
  private let cacheDirectory: URL
  private let logger = Logger(subsystem: "SessionData", category: "CacheManager")

  init(directory: String) {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first!
    self.cacheDirectory = documentsPath.appendingPathComponent(directory, isDirectory: true)

    // Create cache directory if it doesn't exist
    do {
      try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    } catch {
      logger.error("Failed to create cache directory: \(error.localizedDescription)")
    }
  }

  func save(_ data: Data, for key: String) {
    let fileURL = cacheDirectory.appendingPathComponent(key)
    do {
      try data.write(to: fileURL)
      logger.debug("Successfully cached data for key: \(key)")
    } catch {
      logger.error("Failed to save cache for key \(key): \(error.localizedDescription)")
    }
  }

  func load(for key: String) -> Data? {
    let fileURL = cacheDirectory.appendingPathComponent(key)
    do {
      let data = try Data(contentsOf: fileURL)
      logger.debug("Successfully loaded cached data for key: \(key)")
      return data
    } catch {
      logger.debug("Failed to load cache for key \(key): \(error.localizedDescription)")
      return nil
    }
  }

  func clear(for key: String) {
    let fileURL = cacheDirectory.appendingPathComponent(key)
    do {
      try FileManager.default.removeItem(at: fileURL)
      logger.debug("Successfully cleared cache for key: \(key)")
    } catch {
      logger.debug("Failed to clear cache for key \(key): \(error.localizedDescription)")
    }
  }

  func clearAll() {
    do {
      let files = try FileManager.default.contentsOfDirectory(
        at: cacheDirectory, includingPropertiesForKeys: nil)
      for file in files {
        try FileManager.default.removeItem(at: file)
      }
      logger.debug("Successfully cleared all cache")
    } catch {
      logger.error("Failed to clear all cache: \(error.localizedDescription)")
    }
  }
}
