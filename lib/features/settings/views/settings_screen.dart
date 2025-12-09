import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Top bar for the settings screen
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Section: Units
              const Text(
                'Units',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Units Card
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: const Color.fromARGB(255, 72, 72, 79), // Dark grey card background
                  child: Column(
                    children: [
                      // Toggle temperature units (Celsius / Fahrenheit)
                      Consumer<SettingsProvider>(
                        builder: (context, settings, _) => ListTile(
                          title: const Text('Temperature units', style: TextStyle(color: Colors.white)),
                          subtitle: const Text('Choose unit for temperature', style: TextStyle(color: Colors.white54)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text((settings.useCelsius == true) ? '°C' : '°F', style: const TextStyle(color: Colors.white70)),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.white70),
                            ],
                          ),
                          onTap: () async {
                            // Flip the temperature unit and persist
                            final newVal = !(settings.useCelsius == true);
                            await settings.setUseCelsius(newVal);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Units set to ${newVal ? '°C' : '°F'}')));
                          },
                        ),
                      ),
                      Divider(color: Colors.white.withOpacity(0.06), height: 1),
                      // Toggle wind speed display (km/h or mph)
                      Consumer<SettingsProvider>(
                        builder: (context, settings, _) => ListTile(
                          title: const Text('Wind speed units', style: TextStyle(color: Colors.white)),
                          subtitle: Text((settings.windKmh == true) ? 'Kilometres per hour (km/h)' : 'Miles per hour (mph)', style: const TextStyle(color: Colors.white54)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text((settings.windKmh == true) ? 'km/h' : 'mph', style: const TextStyle(color: Colors.white70)),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.white70),
                            ],
                          ),
                          onTap: () async {
                            // Flip wind unit preference and persist
                            final newVal = !(settings.windKmh == true);
                            await settings.setWindKmh(newVal);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wind units set to ${newVal ? 'km/h' : 'mph'}')));
                          },
                        ),
                      ),
                      Divider(color: Colors.white.withOpacity(0.06), height: 1),
                      // Toggle pressure display unit (hPa / mbar)
                      Consumer<SettingsProvider>(
                          builder: (context, settings, _) => ListTile(
                          title: const Text('Atmospheric pressure units', style: TextStyle(color: Colors.white)),
                          subtitle: Text((settings.pressureHpa == true) ? 'Hectopascal (hPa)' : 'Millibar (mbar)', style: const TextStyle(color: Colors.white54)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text((settings.pressureHpa == true) ? 'hPa' : 'mbar', style: const TextStyle(color: Colors.white70)),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Colors.white70),
                            ],
                          ),
                          onTap: () async {
                            // Flip pressure unit preference and persist
                            final newVal = !(settings.pressureHpa == true);
                            await settings.setPressureHpa(newVal);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pressure units set to ${newVal ? 'hPa' : 'mbar'}')));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // About / Feedback / Privacy
              // Section: About / Feedback
              const Text('About Weather', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: const Color.fromARGB(255, 72, 72, 79), // Dark grey card background
                  child: Column(
                    children: [
                      // Feedback / Privacy are placeholders that show a SnackBar
                      ListTile(
                        title: const Text('Feedback', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback (demo)'))),
                      ),
                      Divider(color: Colors.white.withOpacity(0.06), height: 1),
                      ListTile(
                        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy Policy (demo)'))),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}