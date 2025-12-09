import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favoriteCities = [];

  List<String> get favoriteCities => _favoriteCities;

  // Constructor: Load data as soon as the provider is created
  FavoritesProvider() {
    loadFavorites();
  }

  // Create (Add a city)
  Future<void> addCity(String cityName) async {
    if (!_favoriteCities.contains(cityName)) {
      _favoriteCities.add(cityName);
      await _saveToStorage();
      notifyListeners();
    }
  }

  // Read (Load from storage)
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // defaulting to an empty list if nothing is found
    _favoriteCities = prefs.getStringList('favorite_cities') ?? [];
    notifyListeners();
  }

  // Delete (Remove a city)
  Future<void> removeCity(String cityName) async {
    _favoriteCities.remove(cityName);
    await _saveToStorage();
    notifyListeners();
  }

  // Helper to save current list to storage
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_cities', _favoriteCities);
  }

  // Helper to check if a city is already favorited (for UI icons)
  bool isCityFavorite(String cityName) {
    return _favoriteCities.contains(cityName);
  }
}