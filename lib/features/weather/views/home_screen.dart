import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/weather_provider.dart';
import '../../settings/views/settings_screen.dart';
import '../../settings/viewmodels/settings_provider.dart';
import 'forecast_detail_screen.dart';
import '../../favorites/viewmodels/views/favorites_screen.dart';
import '../../favorites/viewmodels/favorites_provider.dart';
import '../../weather/views/weather_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  VoidCallback? _settingsListener;
  // Controller for the search input and a listener to refresh on unit changes

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(
        context,
        listen: false,
      ).fetchWeatherData("London");

      // Fetch initial city (London) once after first frame

      // Listen for unit changes so we can refresh displayed weather
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      _settingsListener = () {
        final weatherProv = Provider.of<WeatherProvider>(context, listen: false);
        final city = weatherProv.weather?.cityName;
        if (city != null) {
          weatherProv.fetchWeatherData(city);
        }
      };
      settings.addListener(_settingsListener!);
    });
  }

  @override
  void dispose() {
    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      // Remove listener to avoid memory leaks when screen is disposed
      if (_settingsListener != null) settings.removeListener(_settingsListener!);
    } catch (_) {}
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Responsive spacing values
    final screenHeight = MediaQuery.of(context).size.height;
    final double forecastGap = (screenHeight * 0.03)
        .clamp(20.0, 80.0)
        .toDouble();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
           IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherDetailsScreen(weather: weatherProvider.weather!),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 7, 123, 255), // Rich Blue (Top)
                  Color.fromARGB(255, 89, 158, 222), // Soft Blue (Middle)
                  Color.fromARGB(255, 133, 208, 255), // Light Sky Blue (Bottom)
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          constraints.maxHeight -
                          30, // Adjust for padding (top 10 + bottom 20)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Section: Search + Current Weather Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search Bar
                            TextField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                hintText: 'Search City...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 20,
                                ),
                              ),
                                // When user submits a city, fetch its weather
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    weatherProvider.fetchWeatherData(value);
                                  }
                                },
                            ),

                            const SizedBox(height: 30),

                            // Main Weather Content (Top Part)
                            if (weatherProvider.isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            else if (weatherProvider.errorMessage.isNotEmpty)
                              Center(
                                child: Text(
                                  weatherProvider.errorMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else if (weatherProvider.weather != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // City Name
                                  // City Name & Favorite Icon
                                  Row(
                                    children: [
                                      Text(
                                        weatherProvider.weather!.cityName,
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Consumer<FavoritesProvider>(
                                        builder: (context, favoritesProvider, child) {
                                          final isFavorite = favoritesProvider.isCityFavorite(weatherProvider.weather!.cityName);
                                          return IconButton(
                                            icon: Icon(
                                              isFavorite ? Icons.favorite : Icons.favorite_border,
                                              color: isFavorite ? Colors.redAccent : Colors.white,
                                              size: 32,
                                              shadows: const [
                                                Shadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            // Favorite toggle: add/remove city from saved list
                                              onPressed: () {
                                              final cityName = weatherProvider.weather!.cityName;
                                              if (isFavorite) {
                                                favoritesProvider.removeCity(cityName);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('$cityName removed from favorites')),
                                                );
                                              } else {
                                                favoritesProvider.addCity(cityName);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('$cityName added to favorites')),
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    DateFormat(
                                      'EEEE, d MMMM',
                                    ).format(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  SizedBox(height: forecastGap),

                                  // Temperature & Icon Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${weatherProvider.weather!.temperature.toStringAsFixed(0)}°',
                                            style: const TextStyle(
                                              fontSize: 80,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0, 4),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            weatherProvider.weather!.description
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://openweathermap.org/img/wn/${weatherProvider.weather!.iconCode}@4x.png',
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                                Icons.error,
                                                color: Colors.white,
                                              ),
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 30),
                                ],
                              ),
                          ],
                        ),

                        // Bottom Section: Forecast Card
                        if (weatherProvider.weather != null) ...[
                          const SizedBox(height: 20),
                          // Forecast Card (matches provided design)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final screenHeight = MediaQuery.of(
                                context,
                              ).size.height;
                              final containerHeight = (screenHeight * 0.36)
                                  .clamp(220.0, 420.0);
                              // final availableWidth = constraints.maxWidth; // unused

                              // Build min/max across available temps for progress bars
                              final temps = weatherProvider.forecast
                                  .map((d) => d.temperature)
                                  .toList();
                              final double minTemp = temps.isNotEmpty
                                  ? temps.reduce((a, b) => a < b ? a : b)
                                  : 0.0;
                              final double maxTemp = temps.isNotEmpty
                                  ? temps.reduce((a, b) => a > b ? a : b)
                                  : 1.0;

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 15,
                                    sigmaY: 15,
                                  ),
                                  child: Container(
                                    height: containerHeight,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4B9EEB),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        // Header inside card
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              child: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Expanded(
                                              child: Text(
                                                '5-day forecast',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ForecastDetailScreen(),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'More details',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        // Forecast rows
                                        Expanded(
                                          child: ListView.separated(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            // Preview only 3 items here; full list is in ForecastDetailScreen
                                            itemCount:
                                                weatherProvider
                                                        .forecast
                                                        .length >
                                                    3
                                                ? 3
                                                : weatherProvider
                                                      .forecast
                                                      .length,
                                            separatorBuilder:
                                                (context, index) => Divider(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  height: 1,
                                                ),
                                            itemBuilder: (context, index) {
                                              final day = weatherProvider
                                                  .forecast[index];
                                              final date = DateTime.parse(
                                                day.date,
                                              );
                                              final dayLabel = DateFormat(
                                                'EEE',
                                              ).format(date);
                                              final double temp =
                                                  day.temperature;
                                                    // Compute normalized fraction for progress-like bar
                                                    final double tMin = minTemp;
                                                    final double tMax =
                                                      maxTemp == tMin
                                                      ? tMin + 1
                                                      : maxTemp;
                                                    final double fraction =
                                                      ((temp - tMin) /
                                                          (tMax - tMin))
                                                        .clamp(0.0, 1.0);

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 88,
                                                      child: Text(
                                                        dayLabel,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    CachedNetworkImage(
                                                      imageUrl:
                                                          'https://openweathermap.org/img/wn/${day.iconCode}.png',
                                                      width: 28,
                                                      height: 28,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          // Left temp
                                                          Text(
                                                            '${temp.toStringAsFixed(0)}°',
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          // Progress-like bar
                                                          Expanded(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height: 8,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                          0.1,
                                                                        ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                ),
                                                                FractionallySizedBox(
                                                                  widthFactor:
                                                                      fraction,
                                                                  child: Container(
                                                                    height: 8,
                                                                    decoration: BoxDecoration(
                                                                      gradient: const LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                            0xFFFFC857,
                                                                          ),
                                                                          Color(
                                                                            0xFFFA7B59,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          // Right temp (show same temp if high/low not available)
                                                          Text(
                                                            '${temp.toStringAsFixed(0)}°',
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        const SizedBox(height: 12),
                                        // Bottom full-width button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                    Colors.white.withOpacity(
                                                      0.12,
                                                    ),
                                                  ),
                                              foregroundColor:
                                                  WidgetStateProperty.all(
                                                    Colors.white,
                                                  ),
                                              elevation:
                                                  WidgetStateProperty.all(0),
                                              shadowColor:
                                                  WidgetStateProperty.all(
                                                    Colors.transparent,
                                                  ),
                                              overlayColor:
                                                  WidgetStateProperty.all(
                                                    Colors.transparent,
                                                  ),
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              shape: WidgetStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForecastDetailScreen(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              '5-day forecast',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
