import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/weather_provider.dart';

class ForecastDetailScreen extends StatelessWidget {
  const ForecastDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final forecastList = weatherProvider.forecast;

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows gradient to go behind AppBar
      appBar: AppBar(
        title: const Text("5-Day Forecast", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Makes back button white
      ),
      body: Container(
        // Match the Home Screen Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B72CF), // Rich Blue (Top)
              Color(0xFF649CE6), // Soft Blue (Middle)
              Color(0xFF9AC6F7), // Light Sky Blue (Bottom)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: forecastList.isEmpty
              ? const Center(child: Text("No forecast data available", style: TextStyle(color: Colors.white)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.separated(
                    itemCount: forecastList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final day = forecastList[index];
                      final date = DateTime.parse(day.date);
                      final dayName = DateFormat('EEEE').format(date); // "Monday"
                      final fullDate = DateFormat('MMM d').format(date); // "Oct 25"

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1), // Darker tint for contrast
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left Side: Day and Date
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dayName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // White text
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      fullDate,
                                      style: const TextStyle(
                                        color: Colors.white70, // Slightly faded white
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                // Center: Weather Icon and Description
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: 'https://openweathermap.org/img/wn/${day.iconCode}.png',
                                      width: 50,
                                      height: 50,
                                      // Optional: Tint icon white if you prefer flat icons
                                      // color: Colors.white, 
                                      errorWidget: (context, url, error) => const Icon(Icons.cloud, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      day.description, 
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),

                                // Right Side: Temperature
                                Text(
                                  '${day.temperature.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // White text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}