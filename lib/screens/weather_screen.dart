import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CurrentWeatherScreen extends StatefulWidget {
  @override
  _CurrentWeatherScreenState createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter city'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                weatherProvider.getWeather(_controller.text);
              }
            },
            child: Text('Search Weather'),
          ),
          SizedBox(height: 20),
          if (weatherProvider.errorMessage != null)
            Text(weatherProvider.errorMessage!),
          if (weatherProvider.currentWeather != null) ...[
            Text(
              'Current: ${weatherProvider.currentWeather!['main']['temp']} °C',
              style: TextStyle(fontSize: 24),
            ),
            Text(weatherProvider.currentWeather!['weather'][0]['description']),
          ],
        ],
      ),
    );
  }
}
