# Weather App

**Overview**

A lightweight Flutter weather application that displays current weather and a 5-day forecast, supports favorites, and allows users to choose temperature, wind and pressure units. State is managed with Provider, and user preferences are persisted with SharedPreferences.

**Key Features**
- Current weather (temperature, description, icon)
- 5-day forecast preview and detail screen
- Favorites: add/remove cities, swipe-to-delete, multi-select deletion
- Persistent user settings: temperature unit (°C/°F), wind unit (km/h or mph), pressure unit (hPa or mbar)
- Per-city caching for favorites to avoid unnecessary network requests

**Repository Structure (important files)**
- `lib/main.dart` — App entry and Provider registrations
- `lib/features/weather/viewmodels/weather_provider.dart` — Fetches weather & forecast (uses OpenWeather API)
- `lib/features/weather/views/home_screen.dart` — Main UI
- `lib/features/weather/views/weather_details_screen.dart` — Detailed metrics (pressure, wind, humidity, etc.)
- `lib/features/weather/models/weather_model.dart` — Weather model
- `lib/features/favorites/viewmodels/favorites_provider.dart` — Favorites persistence
- `lib/features/favorites/viewmodels/views/favorites_screen.dart` — Favorites UI (caching + multi-select)
- `lib/features/settings/viewmodels/settings_provider.dart` — Persists user preferences (temperature, wind, pressure)
- `lib/features/settings/views/settings_screen.dart` — Settings UI

**Prerequisites**
- Flutter SDK (stable). Follow Flutter's official install guide: https://flutter.dev/docs/get-started/install
- Platform toolchains (Android SDK, Xcode for macOS/iOS if targeting those platforms)
- Recommended editor: VS Code or Android Studio with Flutter & Dart plugins

**Install dependencies**
Open a PowerShell terminal in the project root and run:

```powershell
flutter pub get
```

If you add new packages, run the same command again.

**API Key Configuration**
This app uses the OpenWeather API. By default the API key is present in `lib/features/weather/viewmodels/weather_provider.dart` as a constant. For development you can either:

- Replace the hard-coded `_apiKey` value in `lib/features/weather/viewmodels/weather_provider.dart` with your own API key.

Or, for a safer approach, use an environment variable or `flutter_dotenv`:

1. Add `flutter_dotenv` to `pubspec.yaml`.
2. Create a `.env` file with `OPENWEATHER_API_KEY=your_key_here`.
3. Load the env in `main.dart` and read it in `WeatherProvider`.

**Run the app (PowerShell)**

Run on the default connected device/emulator:

```powershell
flutter run
```

Run on Windows desktop (if configured):

```powershell
flutter run -d windows
```

Run on a specific Android emulator (example):

```powershell
flutter emulators
flutter emulators --launch <emulatorId>
flutter run -d emulator-5554
```

Run analyzer and tests:

```powershell
flutter analyze
flutter test
```

**How settings & units work**
- Temperature: toggled in `SettingsScreen`; persisted by `SettingsProvider`. The `WeatherProvider` reads the preference when building API requests and requests metric (`units=metric`) or imperial (`units=imperial`) accordingly.
- Wind: stored as `windKmh` in `SettingsProvider`. The details UI converts API-returned wind values to km/h or mph for display.
- Pressure: stored as `pressureHpa` in `SettingsProvider`. OpenWeather returns pressure in hPa (same as mbar); the app changes the label between `hPa` and `mbar`.

**Favorites behavior**
- Favorites are persisted using SharedPreferences in `FavoritesProvider`.
- The Favorites screen caches per-city weather futures to avoid re-fetching on rebuild.
- Long-press enters selection mode for multi-delete; swipe-to-delete is supported on each row.

**Developer notes & suggestions**
- `WeatherProvider` currently reads `SharedPreferences` on each fetch to decide API `units`. For better performance you can inject `SettingsProvider` into `WeatherProvider` so it listens for changes and maintains an in-memory unit flag.
- Consider removing hard-coded API keys from source and using environment variables or encrypted secrets for release builds.
- The `analysis_options.yaml` references packages that may not be installed in all environments — run `flutter pub get` and ensure your environment matches the expected SDK versions.

**Common Troubleshooting**
- "Null is not a subtype of type 'bool'": occurs when reading booleans from prefs or provider before they've been initialized. We added defensive checks (compare with `== true`) in UI files to mitigate this. Ensure `SettingsProvider` has loaded before expecting non-null values.
- Missing platform toolchains: refer to Flutter setup docs for Android/iOS/desktop specifics.

**Contributing**
- Fork and create a branch for feature work: `feature/your-feature`.
- Keep changes small and focused; add tests where appropriate.
- Run `flutter analyze` and `flutter test` before opening a PR.

If you want, I can:
- Move API key handling to `flutter_dotenv` and update `main.dart`.
- Inject `SettingsProvider` into `WeatherProvider` so API calls use the in-memory preference (avoid repeated SharedPreferences access).
- Add Undo action to the favorites SnackBar to restore a removed city.

---

If you'd like edits to any section or want me to implement one of the optional improvements now, tell me which and I'll proceed.
