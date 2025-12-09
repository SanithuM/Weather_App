import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/weather/viewmodels/weather_provider.dart';
import 'features/favorites/viewmodels/favorites_provider.dart';
import 'features/settings/viewmodels/settings_provider.dart';
import 'features/weather/views/home_screen.dart';

void main() {
  // Entry point: start the Flutter app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide app-wide settings first so other providers can read them
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // Weather state & logic (fetching/parsing API responses)
        ChangeNotifierProvider(create: (_) => WeatherProvider()),

        // Favorites state (persisted list of cities)
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(), // The main weather screen
      ),
    );
  }
}