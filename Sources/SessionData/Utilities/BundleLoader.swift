import Foundation

struct BundleLoader {
  enum BundleLoaderError: Error {
    case resourceNotFound(String)
    case dataLoadingFailed(String)
  }

  func load(file: String) throws -> Data {
    guard
      let url = Bundle.sessionData.url(
        forResource: file.replacingOccurrences(of: ".json", with: ""), withExtension: "json")
    else {
      throw BundleLoaderError.resourceNotFound("Resource \(file) not found in bundle")
    }

    do {
      return try Data(contentsOf: url)
    } catch {
      throw BundleLoaderError.dataLoadingFailed("Failed to load data from \(file): \(error)")
    }
  }
}
