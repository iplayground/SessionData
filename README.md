# 格式說明

以下將說明幾個不同區塊分別使用的 .json，以及對應到網站的欄位

## 行程表
資訊處理規則
1. 陣列配置順序，即為代表活動時間的排序
2. 當 speaker 和 description 都沒有內容(沒有參數或是 "")的時候，展開功能和按鈕會消失
3. speakerID 可用來關聯講者資料，建立講者詳細資訊的連結

參數說明：
* time - 時段，純文字，無特定格式轉換（必要欄位）
* title - 標題，純文字，無特定格式轉換（必要欄位）
* tags - 標籤欄位，陣列帶純文字，無特定格式轉換
* speaker - 講者名稱，純文字，無特定格式轉換，展開後可見
* speakerID - 講者 ID，整數，對應講者資料的 id 欄位（非必要）
* description - 詳細描述，純文字，支援換行顯示（請使用\n），展開後可見

範例：
```json
    {
        "time": "09:50 – 10:40",
        "title": "Let's Functional Programming in Your Swift Code",
        "tags": ["Swift", "函數式"],
        "speaker": "鄭宇哲 UJ Cheng",
        "speakerID": 1,
        "description": "如何讓 Swift 程式碼更簡潔、可讀，是許多開發者追求的目標。函數式編程提供了一種更具表達力的寫法，讓我們能以直觀的語意處理資料與邏輯。本演講將介紹 Swift 到目前為止有的高階函數與使用技巧，並實際示範它們如何應用在 iOS 專案開發中，甚至是在刷題過程中。無論是提升演算法解題效率，還是改善專案架構，Functional Programming 都能為你的 Swift 程式碼帶來優雅的轉變。"
    }
```

## 講者群
資訊處理規則
1. 陣列配置順序，即為顯示的排序（由左到右，上而下）
2. 網址格式內容，請用 https:// 開頭避免跳轉失敗，並在有填寫內容的情況才會顯示對應 icon

參數說明：
* id - 唯一辨識碼，不重複整數，無特定格式轉換（必要欄位）
* name - 講者名稱，純文字，無特定格式轉換（必要欄位）
* title - 標題（頭銜），純文字，無特定格式轉換
* photo - 照片網址，純文字，無特定格式轉換（非必要，但會顯示預設圖片）
    - 照片網址通用結構：https://raw.githubusercontent.com/iplayground/SessionData/2025/v1/images/speakers/ + "檔案完整名稱"

```
以下欄位點開頭像後可見
```
* intro - 詳細介紹，純文字，支援換行顯示（請使用\n）
* url - 自訂網站，網址格式
* fb - facebook 頁面，網址格式
* github - GitHub 頁面，網址格式
* linkedin - LinkedIn 頁面，網址格式
* threads - Threads 頁面，網址格式
* x - x.com 頁面，網址形式
* ig[尚未實作，可先配置] - Instagram 頁面，網址格式


範例：
```json
	{
      "id": 1,
	  "name": "鄭宇哲 UJ Cheng",
	  "title": "Garmin Advanced Software Engineer",
      "intro": "Advanced Software Engineer at Garmin. 10 years of iOS development experience since college. Love solving the LeetCode problems with Swift.",
	  "photo": "https://raw.githubusercontent.com/iplayground/SessionData/2025/v1/images/speakers/speaker_%E9%84%AD%E5%AE%87%E5%93%B2.jpg",
	  "url": "https://leetcode.com/u/iamhands0me",
      "fb": "https://www.facebook.com/hands0me.cheng",
      "github": "https://github.com/iamhands0me",
      "linkedin": "https://www.linkedin.com/in/iamhands0me/",
      "threads": "https://www.threads.com/@iamhands0me",
      "x": "https://x.com/iamhands0me",
      "ig": ""
	},
```

## 贊助商和合作夥伴
資訊處理規則
1. sponsors 為分級陣列，依照配置順序顯示（由上到下）
2. 每個分級下 items 為贊助商陣列，依照配置順序顯示（由左到右）
3. partner 為合作夥伴陣列，依照配置順序顯示

參數說明：
* `sponsors.title` - 分級名稱，純文字
* `sponsors.items[].name` - 贊助商名稱，純文字
* `sponsors.items[].picture` - logo 圖片網址，純文字
* `sponsors.items[].link` - 贊助商網址，純文字
* `partner[].name` - 合作夥伴名稱，純文字
* `partner[].icon` - 合作夥伴 logo 圖片網址，純文字
* `partner[].link` - 合作夥伴網址，純文字

範例：
```json
{
  "sponsors": [
    {
      "title": "鑽石級",
      "items": [
        {
          "name": "RevenueCat",
          "picture": "https://raw.githubusercontent.com/iplayground/SessionData/2025/v1/images/sponsors/logo_revenuecat.png",
          "link": "https://www.revenuecat.com/"
        }
      ]
    },
    {
      "title": "白銀級",
      "items": [
        {
          "name": "Dcard",
          "picture": "https://raw.githubusercontent.com/iplayground/SessionData/2025/v1/images/sponsors/logo_dcard.png",
          "link": "https://www.dcard.tw"
        }
      ]
    }
  ],
  "partner": [
    {
      "name": "CoocaHeads Taipei",
      "icon": "https://raw.githubusercontent.com/iplayground/SessionData/2025/v1/images/partner/logo_cocoaheads_taipei.png",
      "link": "https://www.facebook.com/groups/cocoaheads.taipei/"
    }
  ]
}
```

## 相關連結
資訊處理規則
1. 陣列配置順序，即為顯示的排序（由上到下）
2. 透過 type 分類不同類型的連結

參數說明：
* id - 唯一辨識碼，純文字，無特定格式轉換（必要欄位）
* title - 連結標題，純文字，無特定格式轉換（必要欄位）
* url - 連結網址，網址格式（必要欄位）
* icon - SF Symbols 圖示名稱，純文字（非必要）
* type - 連結類型，枚舉值：`primary`、`social`、`appInfo`（必要欄位）

範例：
```json
[
  {
    "id": "official-website",
    "title": "iPlayground 官網",
    "url": "https://iplayground.io",
    "icon": "globe",
    "type": "primary"
  },
  {
    "id": "registration",
    "title": "報名連結", 
    "url": "https://iplayground.kktix.cc/events/iplayground2025",
    "icon": "ticket",
    "type": "primary"
  },
  {
    "id": "facebook",
    "title": "Facebook 粉絲頁",
    "url": "https://www.facebook.com/iplayground.io",
    "icon": "person.2",
    "type": "social"
  }
]
```

## Swift Package

此專案同時提供 Swift Package，讓 iOS/macOS 專案可以直接整合使用。

### 安裝方式

在 Xcode 中：
1. File → Add Package Dependencies
2. 輸入：`https://github.com/iplayground/SessionData`
3. 選擇適當的版本

或在 Package.swift 中添加：

```swift
dependencies: [
    .package(
        url: "https://github.com/iplayground/SessionData", 
        from: "2025.0.0"
    )
]
```

### 基本使用方式

```swift
import SessionData

let client = SessionDataClient.live

// 使用預設語言（繁體中文）取得資料，預設為 .remote 策略
let allSessions = try await client.fetchSchedules(nil, .fallback)
let day1Sessions = try await client.fetchSchedules(1, .fallback)  
let speakers = try await client.fetchSpeakers(.fallback)
let sponsors = try await client.fetchSponsors()
let staffs = try await client.fetchStaffs()
let links = try await client.fetchLinks()
```

### 獲取策略

SessionData 提供三種資料獲取策略：

```swift
// .remote（預設）：網路 → 緩存 → 本地檔案的完整回退鏈
let sessions = try await client.fetchSchedules(1, .fallback, strategy: .remote)

// .cacheFirst：緩存 → 本地檔案（適合快速 UI 顯示）
let cachedSessions = try await client.fetchSchedules(1, .fallback, strategy: .cacheFirst)

// .localOnly：僅使用本地檔案（適合離線模式）
let offlineSessions = try await client.fetchSchedules(1, .fallback, strategy: .localOnly)
```

### 多語言支援

SessionData 支援繁體中文、英文和日文三種語言：

```swift
// 直接指定語言，使用預設 .remote 策略
let englishSessions = try await client.fetchSchedules(1, .english)
let japaneseSpeakers = try await client.fetchSpeakers(.japanese)
let chineseSessions = try await client.fetchSchedules(1, .traditionalChinese)

// 組合使用語言和策略
let offlineEnglishSessions = try await client.fetchSchedules(1, .english, strategy: .localOnly)

// 使用系統語言自動偵測
import Foundation

let userLocale = Locale.current.identifier
let language = DataLanguage(localeIdentifier: userLocale)
let localizedSessions = try await client.fetchSchedules(2, language)
```

### 語言偵測規則

`DataLanguage(localeIdentifier:)` 支援從 locale 識別碼自動偵測語言：

- `zh*` 開頭 → 繁體中文
- `ja*` 開頭 → 日文  
- 其他 → 英文

### 支援的資料類型

| 資料類型 | 支援多語言 | 對應檔案 |
|---------|-----------|----------|
| 行程表 (Sessions) | ✅ | `schedule.json`, `schedule_en.json`, `schedule_jp.json` |
| 講者 (Speakers) | ✅ | `speakers.json`, `speakers_en.json`, `speakers_jp.json` |
| 贊助商 (Sponsors) | ❌ | `sponsors.json` |
| 工作人員 (Staffs) | ❌ | `staffs.json` |  
| 相關連結 (Links) | ❌ | `links.json` |

### 策略詳細說明

#### `.remote`（預設策略）
完整的三層回退機制：
1. **網路優先**：從 GitHub 獲取最新的 JSON 資料
2. **本地緩存**：網路失敗時使用之前緩存的資料  
3. **內建資源**：完全離線時使用打包在 app 內的 JSON 檔案

#### `.cacheFirst`
快速 UI 顯示策略：
1. **緩存優先**：立即返回緩存的資料（如果有）
2. **內建資源**：沒有緩存時使用打包的 JSON 檔案

適合需要瞬間顯示 UI 的場景，app 端可同時觸發遠端資料更新。

#### `.localOnly`  
純離線策略：
- **僅內建資源**：只使用打包在 app 內的 JSON 檔案
- 適合完全離線模式或確保資料一致性的場景

### 實用範例

```swift
// App 啟動時快速顯示 UI
let cachedSessions = try await client.fetchSchedules(nil, .fallback, strategy: .cacheFirst)
// 同時在背景更新資料
Task {
    let latestSessions = try await client.fetchSchedules(nil, .fallback, strategy: .remote)
    // 更新 UI
}

// 完全離線模式
let offlineSessions = try await client.fetchSchedules(nil, .fallback, strategy: .localOnly)
let offlineSpeakers = try await client.fetchSpeakers(.fallback, strategy: .localOnly)

// 混合使用：關鍵資料用緩存，其他資料用網路
let sessions = try await client.fetchSchedules(1, .fallback, strategy: .cacheFirst)
let sponsors = try await client.fetchSponsors(strategy: .remote)
```

### 測試用法

```swift
// 注意：SessionDataClient.local 已移除
// 請使用 .localOnly 策略替代
let bundleSessions = try await client.fetchSchedules(nil, .fallback, strategy: .localOnly)

// Mock 客戶端（測試用，返回空資料）
let mockClient = SessionDataClient.mock
let emptySessions = try await mockClient.fetchSchedules(nil, .fallback, strategy: .remote)
```

