import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Needed for time formatting
import 'package:provider/provider.dart';
import '../../settings/viewmodels/settings_provider.dart';
import '../models/weather_model.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Current Details", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                  Color.fromARGB(255, 7, 123, 255), // Rich Blue (Top)
                  Color.fromARGB(255, 89, 158, 222), // Soft Blue (Middle)
                  Color.fromARGB(255, 133, 208, 255), // Light Sky Blue (Bottom)
                ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
              child: GridView.count(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3, // Make cards rectangular
              children: [
                _buildDetailCard(Icons.water_drop, "Humidity", "${weather.humidity}%"),
                _buildDetailCard(Icons.air, "Wind Speed", _formatWind(weather, settings)),
                _buildDetailCard(Icons.speed, "Pressure", _formatPressure(weather, settings)),
                _buildDetailCard(Icons.visibility, "Visibility", "${(weather.visibility / 1000).toStringAsFixed(1)} km"),
                _buildDetailCard(Icons.wb_sunny, "Sunrise", _formatTime(weather.sunrise)),
                _buildDetailCard(Icons.nights_stay, "Sunset", _formatTime(weather.sunset)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatWind(WeatherModel weather, SettingsProvider settings) {
    // Determine what units the API returned for wind.
    // WeatherProvider fetches using the temperature unit preference (metric => m/s, imperial => mph).
    // We use settings.useCelsius to infer the API wind unit at fetch time.
    double windMs;
    if (settings.useCelsius == true) {
      // API returned m/s
      windMs = weather.windSpeed;
    } else {
      // API returned mph — convert to m/s
      windMs = weather.windSpeed * 0.44704;
    }

    if (settings.windKmh == true) {
      final kmh = windMs * 3.6;
      return '${kmh.toStringAsFixed(1)} km/h';
    } else {
      final mph = windMs * 2.2369362920544;
      return '${mph.toStringAsFixed(1)} mph';
    }
  }

  String _formatPressure(WeatherModel weather, SettingsProvider settings) {
    // OpenWeather returns pressure in hPa (same as mbar). No conversion needed; only label changes.
    final value = weather.pressure;
    return settings.pressureHpa ? '$value hPa' : '$value mbar';
  }

  // Helper to format UNIX timestamp to "6:30 AM"
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('jm').format(date); // Requires intl package
  }

  Widget _buildDetailCard(IconData icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}