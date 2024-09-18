import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic>? currentWeather;
  Map<String, dynamic>? forecast;
  String? errorMessage;

  // Default city
  String defaultCity = 'Mansehra';

  WeatherProvider() {
    getWeather(defaultCity); // Fetch weather for default city on initialization
  }

  Future<void> getWeather(String city) async {
    try {
      currentWeather = await weatherService.fetchCurrentWeather(city);
      forecast = await weatherService.fetchForecast(city);
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
