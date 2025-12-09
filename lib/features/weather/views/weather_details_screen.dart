import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for time formatting
import 'package:provider/provider.dart';
import '../../settings/viewmodels/settings_provider.dart';
import '../models/weather_model.dart';

// Screen that shows detailed current-weather metrics for a location.
class WeatherDetailsScreen extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Read persisted user settings (units) from the provider.
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
                // Humidity (percentage)
                _buildDetailCard(
                  // Uniform leading size so images and icons match visually
                  SizedBox(width: 36, height: 36, child: Icon(Icons.water_drop, color: Colors.white, size: 30)),
                  "Humidity",
                  "${weather.humidity}%",
                ),
                // Wind - value formatted based on user settings
                _buildDetailCard(
                  SizedBox(width: 36, height: 36, child: Icon(Icons.air, color: Colors.white, size: 30)),
                  "Wind Speed",
                  // Format wind according to user unit preferences
                  _formatWind(weather, settings),
                ),
                // Pressure - label switches between hPa and mbar
                _buildDetailCard(
                  SizedBox(width: 36, height: 36, child: Icon(Icons.speed, color: Colors.white, size: 30)),
                  "Pressure",
                  // Show pressure with user's chosen unit label
                  _formatPressure(weather, settings),
                ),
                // Visibility converted to kilometers
                _buildDetailCard(
                  SizedBox(width: 36, height: 36, child: Icon(Icons.visibility, color: Colors.white, size: 30)),
                  "Visibility",
                  "${(weather.visibility / 1000).toStringAsFixed(1)} km",
                ),
                // Sunrise / Sunset formatted to local time
                // Use provided PNG assets for clearer sunrise/sunset visuals
                  _buildDetailCard(
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(child: Image.asset('assets/icons/sunrise.png', fit: BoxFit.contain)),
                    ),
                    "Sunrise",
                    // Convert UNIX timestamp to local human time
                    _formatTime(weather.sunrise),
                  ),
                  _buildDetailCard(
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(child: Image.asset('assets/icons/sunset.png', fit: BoxFit.contain)),
                    ),
                    "Sunset",
                    _formatTime(weather.sunset),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatWind(WeatherModel weather, SettingsProvider settings) {
    // Convert the stored windSpeed into m/s regardless of what the API
    // returned, by inferring the API unit from the temperature setting.
    double windMs;
    if (settings.useCelsius) {
      // Metric fetch: windSpeed is already in m/s
      windMs = weather.windSpeed;
    } else {
      // Imperial fetch: windSpeed is in mph -> convert to m/s
      windMs = weather.windSpeed * 0.44704;
    }

    // Present wind in user's preferred unit (km/h or mph).
    if (settings.windKmh) {
      final kmh = windMs * 3.6;
      return '${kmh.toStringAsFixed(1)} km/h';
    } else {
      final mph = windMs * 2.2369362920544;
      return '${mph.toStringAsFixed(1)} mph';
    }
  }

  String _formatPressure(WeatherModel weather, SettingsProvider settings) {
    // Pressure value is the same for hPa and mbar; only the unit label changes.
    final value = weather.pressure;
    return settings.pressureHpa ? '$value hPa' : '$value mbar';
  }

  // Helper to format UNIX timestamp to "6:30 AM"
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('jm').format(date); // Requires intl package
  }

  // Accept a leading `Widget` so callers can provide an `Icon` or `Image.asset`.
  Widget _buildDetailCard(Widget leading, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4B9EEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Leading widget (Icon or Image) and text laid out vertically inside the card
          // `leading` is sized by the caller (we pass width/height for images)
          leading,
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}