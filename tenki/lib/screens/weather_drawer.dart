import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherDrawer extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherDrawer({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather Forecast',
                  style: GoogleFonts.questrial(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // You can add any additional information or customization here
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8, // Today + next 7 days
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Today
                  return ListTile(
                    title: Text(
                      'Today',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${weatherData['main']['temp']}˚C'),
                  );
                } else {
                  // Next 7 days
                  // You can customize the date based on your API response
                  String date = 'Day ${index + 1}';
                  String temp = '${weatherData['main']['temp']}˚C'; // Replace with actual data

                  return ListTile(
                    title: Text(date),
                    subtitle: Text(temp),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
