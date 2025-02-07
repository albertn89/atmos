import 'package:atmos/models/weather_model.dart';
import 'package:atmos/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  static const String apiKey = 'YOUR_API_KEY';
  final _weatherService = WeatherService(apiKey);
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/fog.json';
      case 'drizzle':
      case 'rain':
        return 'assets/rain.json';
      case 'shower rain':
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 32, 32, 32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Location section
            Column(
              children: [
                const SizedBox(height: 32),
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  _weather?.cityName ?? 'loading city...',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 72),

            // Weather animation and temperature
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 72),
                Text(
                  '${_weather?.temperature.round()}°C',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),

            // Weather condition
            Text(
              _weather?.mainCondition ?? 'loading condition...',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
