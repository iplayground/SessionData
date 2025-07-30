import Foundation

#if canImport(OSLog)
  import OSLog
#endif

actor CacheManager {
  private let cacheDirectory: URL
  #if canImport(OSLog)
    private let logger = Logger(subsystem: "SessionData", category: "CacheManager")
  #endif

  init(directory: String) {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first!
    self.cacheDirectory = documentsPath.appendingPathComponent(directory, isDirectory: true)

    // Create cache directory if it doesn't exist
    do {
      try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    } catch {
      #if canImport(OSLog)
        logger.error("Failed to create cache directory: \(error.localizedDescription)")
      #else
        print("[CacheManager] Failed to create cache directory: \(error.localizedDescription)")
      #endif
    }
  }

  func save(_ data: Data, for key: String) {
    let fileURL = cacheDirectory.appendingPathComponent(key)
    do {
      try data.write(to: fileURL)
      #if canImport(OSLog)
        logger.debug("Successfully cached data for key: \(key)")
      #else
        print("[CacheManager] Successfully cached data for key: \(key)")
      #endif
    } catch {
      #if canImport(OSLog)
        logger.error("Failed to save cache for key \(key): \(error.localizedDescription)")
      #else
        print("[CacheManager] Failed to save cache for key \(key): \(error.localizedDescription)")
      #endif
    }
  }

  func load(for key: String) -> Data? {
    let fileURL = cacheDirectory.appendingPathComponent(key)
    do {
      let data = try Data(contentsOf: fileURL)
      #if canImport(OSLog)
        logger.debug("Successfully loaded cached data for key: \(key)")
      #else
        print("[CacheManager] Successfully loaded cached data for key: \(key)")
      #endif
      return data
    } catch {
      #if canImport(OSLog)
        logger.debug("Failed to load cache for key \(key): \(error.localizedDescription)")
      #else
        print("[CacheManager] Failed to load cache for key \(key): \(error.localizedDescription)")
      #endif
      return nil
    }
  }

  func clear(for key: String) {
    let fileURL = cacheDirectory.appendingPathComponent(key)
    do {
      try FileManager.default.removeItem(at: fileURL)
      #if canImport(OSLog)
        logger.debug("Successfully cleared cache for key: \(key)")
      #else
        print("[CacheManager] Successfully cleared cache for key: \(key)")
      #endif
    } catch {
      #if canImport(OSLog)
        logger.debug("Failed to clear cache for key \(key): \(error.localizedDescription)")
      #else
        print("[CacheManager] Failed to clear cache for key \(key): \(error.localizedDescription)")
      #endif
    }
  }

  func clearAll() {
    do {
      let files = try FileManager.default.contentsOfDirectory(
        at: cacheDirectory, includingPropertiesForKeys: nil)
      for file in files {
        try FileManager.default.removeItem(at: file)
      }
      #if canImport(OSLog)
        logger.debug("Successfully cleared all cache")
      #else
        print("[CacheManager] Successfully cleared all cache")
      #endif
    } catch {
      #if canImport(OSLog)
        logger.error("Failed to clear all cache: \(error.localizedDescription)")
      #else
        print("[CacheManager] Failed to clear all cache: \(error.localizedDescription)")
      #endif
    }
  }
}
