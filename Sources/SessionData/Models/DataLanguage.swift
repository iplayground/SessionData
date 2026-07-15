//
//  DataLanguage.swift
//  SessionData
//
//  Created by ethanhuang on 2025/8/21.
//

import Foundation

public enum DataLanguage: Sendable, CaseIterable {
  case traditionalChinese
  case english

  public static let fallback = DataLanguage.traditionalChinese
}

extension DataLanguage {
  public var speakersFileName: String {
    "speakers\(fileNameSuffix)"
  }

  public var scheduleFileName: String {
    "schedule\(fileNameSuffix)"
  }

  public var fileNameSuffix: String {
    switch self {
    case .traditionalChinese:
      return ""
    case .english:
      return "_en"
    }
  }

  /// Initialize DataLanguage from a locale identifier string
  /// - Parameter localeIdentifier: A supported locale identifier like "en_US" or "zh_TW"
  public init(localeIdentifier: String) {
    if localeIdentifier.hasPrefix("zh") {
      self = .traditionalChinese
    } else {
      self = .english
    }
  }
}
