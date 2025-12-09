class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility; // visibility in meters
  final int sunrise;    // UNIX timestamp (seconds)
  final int sunset;     // UNIX timestamp (seconds)

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
    );
  }
}