# 格式說明

以下將說明幾個不同區塊分別使用的 .json，以及對應到網站的欄位

## 行程表
資訊處理規則
1. 陣列配置順序，即為代表活動時間的排序
2. 當 speaker 和 description 都沒有內容(沒有參數或是 "")的時候，展開功能和按鈕會消失

參數說明：
* time - 時段，純文字，無特定格式轉換（必要欄位）
* title - 標題，純文字，無特定格式轉換（必要欄位）
* tags - 標籤欄位，陣列帶純文字，無特定格式轉換
* speaker - 講者名稱，純文字，無特定格式轉換，展開後可見
* description - 詳細描述，純文字，支援換行顯示（請使用\n），展開後可見

範例：

    {
        "time": "09:50 – 10:40",
        "title": "Let’s Functional Programming in Your Swift Code",
        "tags": ["Swift", "函數式"],
        "speaker": "鄭宇哲 UJ Cheng",
        "description": "如何讓 Swift 程式碼更簡潔、可讀，是許多開發者追求的目標。函數式編程提供了一種更具表達力的寫法，讓我們能以直觀的語意處理資料與邏輯。本演講將介紹 Swift 到目前為止有的高階函數與使用技巧，並實際示範它們如何應用在 iOS 專案開發中，甚至是在刷題過程中。無論是提升演算法解題效率，還是改善專案架構，Functional Programming 都能為你的 Swift 程式碼帶來優雅的轉變。"
    }


## 講者群
資訊處理規則
1. 陣列配置順序，即為顯示的排序（由左到右，上而下）

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
* url - 自訂網站，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon
* fb - facebook 頁面，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon
* github - GitHub 頁面，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon
* linkedin - LinkedIn 頁面，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon
* threads - Threads 頁面，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon
* x - x.com 頁面，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon
* ig[尚未實作，可先配置] - Instagram 頁面，網址形式（請用 https:// 開頭避免跳轉失敗），有連結才會顯示 icon


範例：

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

