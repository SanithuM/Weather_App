// Simple model representing a single daily forecast entry
class ForecastModel {
  final String date; 
  final double temperature;
  final String description;
  final String iconCode;

  ForecastModel({
    required this.date,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      // The API returns the date in text format like "2023-10-25 12:00:00"
      date: json['dt_txt'] ?? '',
      
      // Handle temperature conversion from dynamic to double safely
      temperature: (json['main']['temp'] as num).toDouble(),
      
      // Get the first weather description from the list
      description: json['weather'][0]['description'] ?? '',
      
      // Get the icon code (e.g., '10d' for rain)
      iconCode: json['weather'][0]['icon'] ?? '01d',
    );
  }
}