# News App (SwiftUI, MVVM)

A modern iOS news application built with SwiftUI that fetches real-time news.

<p align="left">
<img src="https://github.com/user-attachments/assets/bdbe003d-904d-4c96-a1d0-14a4687be4f2" alt="App Icon" width="120" height="120" style="margin-bottom: 10px;">  
</p>

**🔗 Repository:** [Check out the News Repository here!](https://github.com/Nazarzbs/NewsNew)
---

## Features

<img width="1000" src="https://github.com/user-attachments/assets/fc3b6adf-5e6d-403e-a5b3-ee47da893873">  

### Core

* 📰 **Top headlines + search** — Default feed shows top headlines; press **Return** to search.
* 🔍 **Search on Return** — Searches are triggered only when the user explicitly submits; no per-character requests.
* ❌ **Cancel to reset** — Dismissing the search clears the query and reloads the default feed.
* 🌐 **Offline-ready** — Disk caching with automatic fallback when requests fail.
* 🔄 **Pull-to-refresh** — Refresh feed anytime via `refreshable`.
* 🖼️ **Optimized images** — `AsyncImage` with placeholders and graceful fallbacks.
* 📱 **Modern UI** — `NavigationStack`, `ContentUnavailableView`, `searchable` and clear loading/error states.
* 🔒 **Robust error handling** — Explicit network/decoding errors surfaced in UI with user-friendly messages.

## Project Structure

```
NewsApp/
├─ Constants.swift
├─ Models.swift
├─ Services/
│  ├─ NewsAPIService.swift
│  └─ CacheService.swift
├─ ViewModels/
│  └─ NewsViewModel.swift
├─ Views/
│  ├─ NewsFeedView.swift
│  ├─ NewsCardView.swift
│  ├─ NewsDetailView.swift
│  └─ WebView.swift
└─ Assets.xcassets
```


