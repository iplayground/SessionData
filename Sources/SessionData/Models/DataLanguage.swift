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
}

extension DataLanguage {
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
}
