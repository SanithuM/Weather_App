import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _kUseCelsiusKey = 'useCelsius';
  static const _kWindKmhKey = 'windKmh';
  static const _kPressureHpaKey = 'pressureHpa';

  bool _useCelsius = true;
  bool _windKmh = true; // true => km/h, false => mph
  bool _pressureHpa = true; // true => hPa, false => mbar (equivalent)
  bool get useCelsius => _useCelsius;
  bool get windKmh => _windKmh;
  bool get pressureHpa => _pressureHpa;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _useCelsius = prefs.getBool(_kUseCelsiusKey) ?? true;
    _windKmh = prefs.getBool(_kWindKmhKey) ?? true;
    _pressureHpa = prefs.getBool(_kPressureHpaKey) ?? true;
    notifyListeners();
  }

  Future<void> setUseCelsius(bool v) async {
    _useCelsius = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kUseCelsiusKey, v);
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
