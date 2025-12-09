import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart'; 

class WeatherProvider extends ChangeNotifier {
  final String _apiKey = '3d7d43845ebdb4790806795505bb4bc3'; 
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherModel? _weather;
  List<ForecastModel> _forecast = []; // This is the private list
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  WeatherModel? get weather => _weather;
  List<ForecastModel> get forecast => _forecast; // This is the getter that fixes the error
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch both current weather and forecast
  Future<void> fetchWeatherData(String cityName) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Determine units from persisted settings
      final prefs = await SharedPreferences.getInstance();
      final useCelsius = prefs.getBool('useCelsius') ?? true;
      final units = useCelsius ? 'metric' : 'imperial';

      // 1. Fetch Current Weather
      final weatherUrl = Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=$units');
      final weatherResponse = await http.get(weatherUrl);

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        _weather = WeatherModel.fromJson(weatherData);

        // 2. Fetch 5-Day Forecast
        await _fetchForecast(cityName); 
        
      } else {
        _errorMessage = 'City not found: $cityName';
        _weather = null;
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again.';
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch current weather for a city without mutating provider state.
  // Returns a WeatherModel or null on failure.
  Future<WeatherModel?> fetchCurrentWeatherOnly(String cityName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final useCelsius = prefs.getBool('useCelsius') ?? true;
      final units = useCelsius ? 'metric' : 'imperial';
      final weatherUrl = Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=$units');
      final weatherResponse = await http.get(weatherUrl);
      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        return WeatherModel.fromJson(weatherData);
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  // Helper method to get the forecast
  Future<void> _fetchForecast(String cityName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final useCelsius = prefs.getBool('useCelsius') ?? true;
      final units = useCelsius ? 'metric' : 'imperial';
      final url = Uri.parse('$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=$units');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];

        // Filter: The API gives data every 3 hours. filter to get just one reading per day (e.g., 12:00 PM).
        _forecast = list
            .where((item) => item['dt_txt'].contains('12:00:00'))
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      print("Error fetching forecast: $e");
    }
  }
}