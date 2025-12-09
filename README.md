# 🌦️ Weather App

![Status - Active](https://img.shields.io/badge/Status-Active-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![State Management](https://img.shields.io/badge/State-Provider-blueviolet?logo=flutter)

A modern, cross-platform mobile weather application developed using `Flutter` and the `OpenWeatherMap API`. This project demonstrates robust software architecture (MVVM), `state management`, and local data persistence without requiring a backend login system.


## 📸 Screenshots

*Screenshots will be added as UI changes are finalized.*

| Home | Forecast | Favorites | Settings |
| :---: | :---: | :---: | :---: |
| ![home](assets/images/home_page.jpg) | ![forecast](assets/images/forecast_page.jpg) | ![favorites](assets/images/favorites_page.jpg) | ![settings](assets/images/settings_page.jpg) |

Replace the placeholder images under `assets/images/` with real screenshots and update this table when ready.

## ✨ Features

- Current weather (temperature, description, icon)
- 5-day forecast preview with detail screen
- Favorites: add/remove cities, swipe-to-delete, long-press multi-select and batch delete
- Persistent user settings: temperature (°C/°F), wind (km/h or mph), pressure (hPa or mbar)
- Per-city favorites caching to reduce network requests
- Responsive UI (LayoutBuilder) and accessible controls

## 🛠 Tech Stack

- Framework: Flutter
- Language: Dart
- Architecture: MVVM with Feature-based folder
- State Management: Provider
- Network: `http`
- Persistence: `shared_preferences`
- API: `OpenWeatherMap`
- Image caching: `cached_network_image`
- Date formatting: `intl`

## 📁 Project Structure

Feature-based layout; only key files shown:

```
lib/
 ┣ features/
 ┃ ┣ weather/
 ┃ ┃ ┣ models/
 ┃ ┃ ┃ ┗ weather_model.dart
 ┃ ┃ ┣ viewmodels/
 ┃ ┃ ┃ ┗ weather_provider.dart
 ┃ ┃ ┗ views/
 ┃ ┃   ┣ home_screen.dart
 ┃ ┃   ┗ weather_details_screen.dart
 ┃ ┣ favorites/
 ┃ ┃ ┣ viewmodels/
 ┃ ┃ ┃ ┗ favorites_provider.dart
 ┃ ┃ ┗ views/
 ┃ ┃   ┗ favorites_screen.dart
 ┃ ┗ settings/
 ┃   ┣ viewmodels/
 ┃   ┃ ┗ settings_provider.dart
 ┃   ┗ views/
 ┃     ┗ settings_screen.dart
 ┣ main.dart
```

## ⚙️ Settings & Units

- Temperature units are persisted via `SettingsProvider` and used to choose the API `units` parameter (`metric` vs `imperial`).
- Wind speed and pressure preferences are persisted and used to format values in the details screen (conversions applied when needed).
- The Home screen listens for settings changes and will refresh the current city's weather automatically when units change.

## ❤️ Favorites

- Favorite cities persist using `SharedPreferences` via `FavoritesProvider`.
- Favorites screen caches per-city weather futures so the list doesn't re-fetch on every rebuild.
- Long-press to enter multi-select mode and delete multiple favorites; swipe a city row to delete a single city.


