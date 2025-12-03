# Weather App

![Status - Active](https://img.shields.io/badge/Status-Active-brightgreen)
![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![State Management](https://img.shields.io/badge/State-Provider-blueviolet?logo=flutter)

A modern Flutter weather application that shows current conditions, a 5-day forecast, and lets users save favorite cities. The app uses a feature-based architecture, `Provider` for state management, and `SharedPreferences` for lightweight persistence.

This README follows a friendly, developer-first style inspired by other well-documented Flutter projects.

## 📸 Screenshots

*Screenshots will be added as UI changes are finalized.*

| Home | Forecast Card | Favorites | Settings |
| :---: | :---: | :---: | :---: |
| ![home](assets/images/home_placeholder.png) | ![forecast](assets/images/forecast_placeholder.png) | ![favorites](assets/images/favorites_placeholder.png) | ![settings](assets/images/settings_placeholder.png) |

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
- State Management: Provider
- Network: `http`
- Persistence: `shared_preferences`
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

## 🔑 API Key (OpenWeather)

This app uses the OpenWeather API. For development you can either set the API key directly in `lib/features/weather/viewmodels/weather_provider.dart` (not recommended for production) or use `flutter_dotenv`:

1. Add `flutter_dotenv` to `pubspec.yaml`.
2. Create a `.env` file in the project root with:

```
OPENWEATHER_API_KEY=your_api_key_here
```

3. Load the env file in `main.dart` and read the key inside `WeatherProvider`.

## 🚀 Getting Started (PowerShell)

1. Clone the repo

```powershell
git clone https://github.com/SanithuM/Weather_App.git
cd Weather_App
```

2. Install dependencies

```powershell
flutter pub get
```

3. Run the app

```powershell
flutter run
```

4. Run analyzer and tests

```powershell
flutter analyze
flutter test
```

## ⚙️ Settings & Units

- Temperature units are persisted via `SettingsProvider` and used to choose the API `units` parameter (`metric` vs `imperial`).
- Wind speed and pressure preferences are persisted and used to format values in the details screen (conversions applied when needed).
- The Home screen listens for settings changes and will refresh the current city's weather automatically when units change.

## ❤️ Favorites

- Favorite cities persist using `SharedPreferences` via `FavoritesProvider`.
- Favorites screen caches per-city weather futures so the list doesn't re-fetch on every rebuild.
- Long-press to enter multi-select mode and delete multiple favorites; swipe a city row to delete a single city.

## Developer Notes

- `WeatherProvider` currently reads `SharedPreferences` for unit selection at fetch-time. For lower latency and simpler testing, consider injecting `SettingsProvider` into `WeatherProvider` so it keeps an in-memory flag and listens for changes.
- Wind unit handling: when requesting `units=metric`, OpenWeather returns wind speed in m/s; when `units=imperial`, wind is returned in mph. The details UI normalizes/scales values for display based on the selected wind unit.
- Pressure: OpenWeather returns pressure in hPa (same numeric value as mbar). The UI will label values as `hPa` or `mbar` per user choice.

## Common Troubleshooting

- `Null is not a subtype of type 'bool'`: Make sure `SettingsProvider` has finished loading preferences before relying on boolean settings. UI uses defensive checks (`== true`) to avoid crashes when values are temporarily null.
- If images fail to load: check network connectivity and that the OpenWeather image URL format is correct.

## Contributing

- Fork the repo and create a feature branch (e.g. `feature/units-conversions`).
- Run `flutter analyze` and `flutter test` before opening a PR.

If you'd like, I can:
- Move API key handling to `.env` with `flutter_dotenv`.
- Inject `SettingsProvider` into `WeatherProvider` so units are observed in-memory.
- Add an Undo action to the favorites SnackBar.

---

If you'd like the README tweaked (more screenshots, badges, or step-by-step developer instructions), tell me which parts to expand and I'll update it.
