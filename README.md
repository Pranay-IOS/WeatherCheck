# 🌦 WeatherCheck

WeatherCheck is a clean and modern iOS weather application built using **Swift**, following the **MVC architecture pattern**.  
It provides real-time and forecasted weather data using network APIs, along with offline support, skeleton loading states, search history, and smooth UI interactions.

---

## ✨ Features

- 🔍 **Search Weather by City**
- 📍 **Auto-detect current location**
- 📅 **6-day forecast**
- ⏰ **Hourly weather updates**
- 💾 **Offline mode with local cache fallback**
- 🧠 **Smart retry logic on network failure**
- 📖 **Search history (last 5 queries saved)**
- 🦴 **Shimmer Skeleton loading animations (SkeletonView)**
- 🔄 **Pull-to-Refresh support**
- 🎨 **Modern UI with gradient backgrounds and icons**

---

## 🧱 Architecture

WeatherCheck follows the **MVC (Model-View-Controller)** pattern:

WeatherCheck
├── Model # Weather data models, decoding logic
├── View # Custom cells, UI components
└── Controller # Business logic + event handling

---

## 🛠 Technologies & Libraries

| Component | Technology |
|----------|------------|
| Language | Swift |
| UI | UIKit |
| Networking | URLSession + Result type |
| JSON Decoding | Codable |
| Skeleton Loading | SkeletonView |
| Offline Cache | UserDefaults storage |
| Location Services | CoreLocation |
| Network Reachability | NWPathMonitor |

---

## 📦 Installation

1. Clone the repository:

    git clone https://github.com/yourusername/WeatherCheck.git

2. Open the project in Xcode:

    open WeatherCheck.xcodeproj

3. Install dependencies (SkeletonView) via Swift Package Manager.

4. Add a valid Weather API key in:

    AppConfig.xcconfig

## 🔑 API Used

This project uses:

WeatherAPI.com Forecast Endpoint

## 🚀 Future Improvements

☁️ Dark mode icon variations

🧭 Widget support for home screen

⏱ Live activity Lock Screen weather updates

🔔 Weather alert notifications

## 🧑‍💻 Author

Pranay Barua
