import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'screens/current_weather_screen.dart';
import 'screens/forecast_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            color: Colors.blueAccent,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        home: WeatherHome(),
      ),
    );
  }
}

class WeatherHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearchDialog(context);
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Current Weather'),
              Tab(text: 'Forecast'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrentWeatherScreen(), // Screen for current weather
            ForecastScreen(), // Screen for forecast
          ],
        ),
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search City'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter city name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .getWeather(_controller.text);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('Get Weather'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Current Weather Screen with additional weather details
class CurrentWeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AnimatedOpacity(
        opacity: weatherProvider.currentWeather != null ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (weatherProvider.currentWeather != null) ...[
                Text(
                  'Location: ${weatherProvider.currentWeather!['name']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.thermostat_outlined, size: 30, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      'Current: ${weatherProvider.currentWeather!['main']['temp']} °C',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.water, size: 30, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      'Humidity: ${weatherProvider.currentWeather!['main']['humidity']}%',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.air, size: 30, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Wind Speed: ${weatherProvider.currentWeather!['wind']['speed']} m/s',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.cloud, size: 30, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Description: ${weatherProvider.currentWeather!['weather'][0]['description']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ] else if (weatherProvider.errorMessage != null) ...[
                Text(weatherProvider.errorMessage!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
