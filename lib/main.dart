import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/weather/viewmodels/weather_provider.dart';
import 'features/favorites/viewmodels/favorites_provider.dart';
import 'features/settings/viewmodels/settings_provider.dart';
import 'features/weather/views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // SettingsProvider should be created before others that may read its value
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // This initializes the Logic/State for the Weather feature
        ChangeNotifierProvider(create: (_) => WeatherProvider()),

        // This initializes the Logic/State for the Favorites feature
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