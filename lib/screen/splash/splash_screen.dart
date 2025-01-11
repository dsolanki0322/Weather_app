import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_weather/config/utils/constant.dart';
import 'package:new_weather/screen/splash/introduction_screen.dart';
import 'package:new_weather/screen/weather/weather_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with WidgetsBindingObserver {
  late Timer timer;
  double percent = 0;

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Loaddata();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.colorbg,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Container(
                    alignment: Alignment.center,

                    //padding: EdgeInsets.symmetric(horizontal: 30),
                  )),
              Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/weather-app.png",
                      height: SizeConfig.blockV,
                    ),
                    //padding: EdgeInsets.symmetric(horizontal: 30),
                  )),
              Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child:
                    Text(
                      "Weather Forecasting Application",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontLRegular),
                    )
                  )),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                              alignment: Alignment.center,
                            )),
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: SpinKitThreeBounce(
                                  size: 30,
                                  color: Constants.colorPrimary,
                                )))
                      ])),
            ]));
  }

  Future<Timer> Loaddata() async {
    return Timer(Duration(seconds: 4), checkFirstSeen);
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _introSeen = (prefs.getBool('intro_seen') ?? false);

    if (_introSeen) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WeatherScreen()));
    } else {
      await prefs.setBool('intro_seen', true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IntroductionScreen()));
    }
  }

}
