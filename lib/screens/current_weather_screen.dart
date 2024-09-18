import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CurrentWeatherScreen extends StatefulWidget {
  @override
  _CurrentWeatherScreenState createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (weatherProvider.currentWeather != null) ...[
            Text(
              'Location: ${weatherProvider.currentWeather!['name']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              'Current: ${weatherProvider.currentWeather!['main']['temp']} °C',
              style: TextStyle(fontSize: 24),
            ),
            Text(weatherProvider.currentWeather!['weather'][0]['description']),
          ] else if (weatherProvider.errorMessage != null) ...[
            Text(weatherProvider.errorMessage!),
          ],
        ],
      ),
    );
  }
}
