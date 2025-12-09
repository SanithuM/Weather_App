import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides app-wide user settings and persists them with `SharedPreferences`.
class SettingsProvider extends ChangeNotifier {
  // Keys used in SharedPreferences to store each setting.
  static const _kUseCelsiusKey = 'useCelsius';
  static const _kWindKmhKey = 'windKmh';
  static const _kPressureHpaKey = 'pressureHpa';

  // Cached setting values (defaults) used by getters/setters.
  bool _useCelsius = true; // true => display temperatures in Celsius
  bool _windKmh = true; // true => show wind in km/h, false => mph
  bool _pressureHpa = true; // true => show pressure in hPa, false => mbar

  // Public read-only accessors for UI code to read current settings.
  bool get useCelsius => _useCelsius;
  bool get windKmh => _windKmh;
  bool get pressureHpa => _pressureHpa;

  // Load saved settings on creation.
  SettingsProvider() {
    _load();
  }

  // Load saved settings from SharedPreferences; fall back to true if not set.
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    // Read persisted bools or use default `true` when absent.
    _useCelsius = prefs.getBool(_kUseCelsiusKey) ?? true;
    _windKmh = prefs.getBool(_kWindKmhKey) ?? true;
    _pressureHpa = prefs.getBool(_kPressureHpaKey) ?? true;
    // Notify listeners after loading so UI can rebuild with the restored values.
    notifyListeners();
  }

  // Update local state and UI immediately, then persist the change.
  Future<void> setUseCelsius(bool v) async {
    _useCelsius = v;
    notifyListeners(); // update UI right away
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kUseCelsiusKey, v); // persist change
  }

  Future<void> setWindKmh(bool v) async {
    _windKmh = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kWindKmhKey, v);
  }

  Future<void> setPressureHpa(bool v) async {
    _pressureHpa = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPressureHpaKey, v);
  }
}
