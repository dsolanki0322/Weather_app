import 'package:flutter/material.dart';
import 'package:new_weather/screen/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'provider/weather_provider.dart';
import 'screen/weather/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
