import Foundation

struct BundleLoader {
  func load(file: String) -> Data {
    guard
      let url = Bundle.sessionData.url(
        forResource: file.replacingOccurrences(of: ".json", with: ""), withExtension: "json"),
      let data = try? Data(contentsOf: url)
    else {
      fatalError("Failed to load \(file) from bundle")
    }
    return data
  }
}
