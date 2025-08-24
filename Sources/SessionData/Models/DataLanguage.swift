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
  case japanese

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
    case .japanese:
      return "_jp"
    }
  }

  /// Initialize DataLanguage from a locale identifier string
  /// - Parameter localeIdentifier: A locale identifier like "en_US", "zh_TW", "ja_JP"
  public init(localeIdentifier: String) {
    if localeIdentifier.hasPrefix("zh") {
      self = .traditionalChinese
    } else if localeIdentifier.hasPrefix("ja") {
      self = .japanese
    } else {
      self = .english
    }
  }
}
