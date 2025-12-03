import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/features/favorites/viewmodels/favorites_provider.dart';
import 'package:weather_app/features/weather/viewmodels/weather_provider.dart';
import 'package:weather_app/features/weather/models/weather_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Map<String, Future<WeatherModel?>> _weatherFutures = {};
  final Set<String> _selected = {};
  bool _selectionMode = false;

  void _ensureFuture(String city, WeatherProvider weatherProvider) {
    if (!_weatherFutures.containsKey(city)) {
      _weatherFutures[city] = weatherProvider.fetchCurrentWeatherOnly(city);
    }
  }

  void _removeCached(String city) {
    _weatherFutures.remove(city);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Favorite Cities", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          if (_selectionMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _selectionMode = false;
                _selected.clear();
              }),
            ),
        ],
      ),
      body: favoritesProvider.favoriteCities.isEmpty
          ? const Center(
              child: Text("No cities added yet!", style: TextStyle(color: Colors.white70)),
            )
          : Stack(
              children: [
                ListView.builder(
                  itemCount: favoritesProvider.favoriteCities.length,
                  itemBuilder: (context, index) {
                    final city = favoritesProvider.favoriteCities[index];
                    _ensureFuture(city, weatherProvider);
                    return Dismissible(
                      key: ValueKey(city),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        favoritesProvider.removeCity(city);
                        _removeCached(city);
                        _selected.remove(city);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$city removed')),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _selectionMode = true;
                              _selected.add(city);
                            });
                          },
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              if (_selectionMode) {
                                setState(() {
                                  if (_selected.contains(city)) {
                                    _selected.remove(city);
                                    if (_selected.isEmpty) _selectionMode = false;
                                  } else {
                                    _selected.add(city);
                                  }
                                });
                                return;
                              }
                              Provider.of<WeatherProvider>(context, listen: false).fetchWeatherData(city);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2F5DB0),
                                borderRadius: BorderRadius.circular(14),
                                border: _selected.contains(city) ? Border.all(color: Colors.white, width: 2) : null,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              child: Row(
                                children: [
                                  if (_selectionMode)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12.0),
                                      child: Icon(
                                        _selected.contains(city) ? Icons.check_circle : Icons.radio_button_unchecked,
                                        color: Colors.white,
                                      ),
                                    ),
                                  Expanded(
                                    child: FutureBuilder<WeatherModel?>(
                                      future: _weatherFutures[city],
                                      builder: (context, snapshot) {
                                        String desc = '';
                                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                          final weather = snapshot.data!;
                                          desc = weather.description;
                                        }
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(city, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 6),
                                            Text(desc.isNotEmpty ? desc : 'Loading...', style: const TextStyle(color: Colors.white70)),
                                          ],
                                        );
                                      },
                                    ),
                                  ),

                                  FutureBuilder<WeatherModel?>(
                                    future: _weatherFutures[city],
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                        final weather = snapshot.data!;
                                        final temp = weather.temperature.toStringAsFixed(0);
                                        return Text('$temp°', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold));
                                      }
                                      return const SizedBox(width: 34, height: 34, child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                if (_selectionMode)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[900],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectionMode = false;
                                  _selected.clear();
                                });
                              },
                              icon: const Icon(Icons.close),
                              label: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                            ),
                            onPressed: _selected.isEmpty
                                ? null
                                : () {
                                    final toRemove = List<String>.from(_selected);
                                    for (final city in toRemove) {
                                      favoritesProvider.removeCity(city);
                                      _removeCached(city);
                                    }
                                    setState(() {
                                      _selectionMode = false;
                                      _selected.clear();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${toRemove.length} city(ies) removed')));
                                  },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}