import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  String _city = 'London';
  String _unit = 'metric';
  Map<String, dynamic> _currentWeather = {};
  List<dynamic> _forecast = [];
  bool _isLoading = false;

  String get city => _city;
  String get unit => _unit;
  Map<String, dynamic> get currentWeather => _currentWeather;
  List<dynamic> get forecast => _forecast;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  WeatherProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _city = prefs.getString('city') ?? 'London';
    _unit = prefs.getString('unit') ?? 'metric';
    notifyListeners();
    await fetchWeather();
  }

  Future<void> fetchWeather() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    final apiKey = 'a18fb66aabd133eced32f19709900c9a';
    try {
      print('Fetching weather for city: $_city');
      final currentWeatherResponse = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$_city&units=$_unit&appid=$apiKey'));

      print('Response status: ${currentWeatherResponse.statusCode}'); // Debugging line

      if (currentWeatherResponse.statusCode == 200) {
        _currentWeather = json.decode(currentWeatherResponse.body);
        _errorMessage = ''; // Clear any previous error messages
        notifyListeners();
        await fetchForecast();

      } else {
        _errorMessage = 'Failed to load weather data: ${currentWeatherResponse.statusCode}';
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = 'Error fetching weather data: $error';
      notifyListeners();
      _isLoading = false;
    } finally {
      _isLoading = false; // Set loading to false
      notifyListeners();
    }
  }

  Future<void> fetchForecast() async {
    final apiKey = 'a18fb66aabd133eced32f19709900c9a';
    try {
      final forecastResponse = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$_city&units=$_unit&appid=$apiKey'));

      if (forecastResponse.statusCode == 200) {
        final data = json.decode(forecastResponse.body);
        _forecast = data['list'].take(3).toList();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load forecast data: ${forecastResponse.statusCode}';
        notifyListeners();

      }
    } catch (error) {
      _errorMessage = 'Error fetching forecast data: $error';
      notifyListeners();
    }
  }

  void setCity(String city) async {
    _city = city;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('city', city);
    await fetchWeather();
  }

  void toggleUnit() async {
    _unit = _unit == 'metric' ? 'imperial' : 'metric';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('unit', _unit);
    await fetchWeather();
  }
}
