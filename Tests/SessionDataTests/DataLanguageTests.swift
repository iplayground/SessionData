import Testing

@testable import SessionData

struct DataLanguageTests {

  // MARK: - Locale Identifier Tests

  @Test(
    "Should detect Traditional Chinese for zh prefix locales",
    arguments: ["zh", "zh_TW", "zh_CN", "zh_HK", "zh_Hant", "zh_Hans", "zh_SG"]
  )
  func detectTraditionalChineseLocales(locale: String) async throws {
    let dataLanguage = DataLanguage(localeIdentifier: locale)
    #expect(dataLanguage == .traditionalChinese)
  }

  @Test("Should detect Japanese for ja prefix locales", arguments: ["ja", "ja_JP"])
  func detectJapaneseLocales(locale: String) async throws {
    let dataLanguage = DataLanguage(localeIdentifier: locale)
    #expect(dataLanguage == .japanese)
  }

  @Test(
    "Should default to English for other locales",
    arguments: [
      "en", "en_US", "en_GB", "fr_FR", "de_DE", "es_ES", "ko_KR", "pt_BR", "ru_RU", "ar_SA",
    ]
  )
  func defaultToEnglishForOtherLocales(locale: String) async throws {
    let dataLanguage = DataLanguage(localeIdentifier: locale)
    #expect(dataLanguage == .english)
  }

  @Test(
    "Should handle edge cases gracefully",
    arguments: ["", " ", "invalid", "zh ", "ja ", "ZH_TW", "JA_JP"]
  )
  func handleEdgeCases(locale: String) async throws {
    let dataLanguage = DataLanguage(localeIdentifier: locale)

    if locale.hasPrefix("zh") {
      #expect(dataLanguage == .traditionalChinese)
    } else if locale.hasPrefix("ja") {
      #expect(dataLanguage == .japanese)
    } else {
      // ZH_TW and JA_JP (uppercase) will default to English since hasPrefix is case-sensitive
      #expect(dataLanguage == .english)
    }
  }

  // MARK: - File Name Tests

  @Test("Should return correct file names for all languages")
  func correctFileNames() async throws {
    #expect(DataLanguage.traditionalChinese.scheduleFileName == "schedule")
    #expect(DataLanguage.traditionalChinese.speakersFileName == "speakers")
    #expect(DataLanguage.traditionalChinese.fileNameSuffix == "")

    #expect(DataLanguage.english.scheduleFileName == "schedule_en")
    #expect(DataLanguage.english.speakersFileName == "speakers_en")
    #expect(DataLanguage.english.fileNameSuffix == "_en")

    #expect(DataLanguage.japanese.scheduleFileName == "schedule_jp")
    #expect(DataLanguage.japanese.speakersFileName == "speakers_jp")
    #expect(DataLanguage.japanese.fileNameSuffix == "_jp")
  }

  @Test("Should maintain consistency between locale detection and file names")
  func localeDetectionConsistency() async throws {
    // Test that locale detection produces expected file names
    let zhTW = DataLanguage(localeIdentifier: "zh_TW")
    #expect(zhTW.scheduleFileName == "schedule")

    let enUS = DataLanguage(localeIdentifier: "en_US")
    #expect(enUS.scheduleFileName == "schedule_en")

    let jaJP = DataLanguage(localeIdentifier: "ja_JP")
    #expect(jaJP.scheduleFileName == "schedule_jp")
  }
}
