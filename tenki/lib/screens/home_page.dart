import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String apiKey = '7c6ff95254a3ac31c3db455e96160f77';
  late Map<String, dynamic> weatherData;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    weatherData = {}; // Initialize with an empty map
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tenki',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
              _openProfileDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToWeatherForecast(context),
          ),
        ],
        centerTitle: true,
      ),
      drawer: buildProfileDrawer(), // Add this line to include the profile drawer
      body: FutureBuilder<Map<String, dynamic>>(
        future: getWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Fetching weather data...');
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else {
            weatherData = snapshot.data!;
            return buildWeatherUI(size);
          }
        },
      ),
    );
  }

  void _navigateToWeatherForecast(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherForecastPage(),
      ),
    );
  }

  void _openProfileDrawer() {
    // Implement your logic to open the profile drawer
    print('Opening Profile Drawer...');
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=Jambi,ID&appid=$apiKey&units=metric');

    try {
      http.Response response = await http.get(url);
      await Future.delayed(const Duration(seconds: 5));

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to load weather data. Status Code: ${response.statusCode}');
        return {}; // Return an empty map in case of failure
      }
    } catch (error) {
      print('Error fetching weather data: $error');
      return {}; // Return an empty map in case of error
    }
  }

  Widget buildWeatherUI(Size size) {
    if (weatherData.isNotEmpty && weatherData.containsKey('name')) {
      return Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.03,
                          ),
                          child: Align(
                            child: Text(
                              '${weatherData['name']}',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black,
                                fontSize: size.height * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.005,
                          ),
                          child: Align(
                            child: Text(
                              'Today',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white54
                                    : Colors.black54,
                                fontSize: size.height * 0.035,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.001,
                          ),
                          child: Align(
                            child: Text(
                              '${weatherData['main']['temp']}˚C',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: size.height * 0.12,
                              ),
                            ),
                          ),
                        ),
                        // Display additional information from the API response
                        if (weatherData['weather'] != null &&
                            weatherData['weather'].isNotEmpty &&
                            weatherData['weather'][0]['description'] != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                            ),
                            child: Align(
                              child: Text(
                                'Description: ${weatherData['weather'][0]['description']}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                        if (weatherData['main']['temp_min'] != null &&
                            weatherData['main']['temp_max'] != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                            ),
                            child: Align(
                              child: Text(
                                'Min Temp: ${weatherData['main']['temp_min']}˚C, Max Temp: ${weatherData['main']['temp_max']}˚C',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                        if (weatherData['main']['pressure'] != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                            ),
                            child: Align(
                              child: Text(
                                'Pressure: ${weatherData['main']['pressure']} hPa',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                        if (weatherData['main']['humidity'] != null)
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.02,
                            ),
                            child: Align(
                              child: Text(
                                'Humidity: ${weatherData['main']['humidity']}%',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Drawer buildProfileDrawer() {
    return Drawer(
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
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    // Your mockup profile picture
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Devin Alfanius',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Developer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherForecastPage extends StatefulWidget {
  @override
  _WeatherForecastPageState createState() => _WeatherForecastPageState();
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  late List<Map<String, dynamic>> forecastData;

  @override
  void initState() {
    super.initState();
    forecastData = [];
    getWeatherForecast();
  }

  Future<void> getWeatherForecast() async {
    String apiKey = '7c6ff95254a3ac31c3db455e96160f77';
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=Jambi,ID&appid=$apiKey&units=metric');

    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> list = data['list'].cast<Map<String, dynamic>>();
        setState(() {
          forecastData = list;
        });
      } else {
        print('Failed to load weather forecast. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching weather forecast: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: ListView.builder(
        itemCount: forecastData.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = forecastData[index];
          return ListTile(
            title: Text('Day ${index + 1}'),
            subtitle: Text('Temperature: ${item['main']['temp']}˚C'),
          );
        },
      ),
    );
  }
}
