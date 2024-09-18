import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import intl package
import '../providers/weather_provider.dart';

class ForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (weatherProvider.forecast != null) ...[
            Text(
              'Forecast for ${weatherProvider.forecast!['city']['name']}:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: weatherProvider.forecast!['list'].length,
                itemBuilder: (context, index) {
                  final item = weatherProvider.forecast!['list'][index];
                  return _buildForecastCard(item);
                },
              ),
            ),
          ] else if (weatherProvider.errorMessage != null)
            Center(child: Text(weatherProvider.errorMessage!, style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildForecastCard(Map<String, dynamic> item) {
    // Extracting date and weather details
    String dateTimeString = item['dt_txt'];
    DateTime dateTime = DateTime.parse(dateTimeString); // Parse the date string
    String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(dateTime); // Format the date
    String formattedTime = DateFormat('h:mm a').format(dateTime); // Format the time
    String temperature = '${item['main']['temp']} °C';
    String description = item['weather'][0]['description'];

    // Optional: Extract icon code if available
    String iconCode = item['weather'][0]['icon'];

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                Text(
                  formattedTime,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    if (iconCode != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            'http://openweathermap.org/img/wn/$iconCode@2x.png',
                            width: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    SizedBox(width: 10),
                    Text(
                      temperature,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.deepOrange),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  description.capitalize(),
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringCasingExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this; // Return empty string if the original string is empty
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
