import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_weather/config/utils/constant.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../provider/weather_provider.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Color getRandomLightColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(128) + 128,
      random.nextInt(120) + 128,
      random.nextInt(108) + 128,
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return WillPopScope(
        onWillPop: () => exit(context),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Weather App',
              style: TextStyle(
                  fontFamily: fontLRegular, fontWeight: FontWeight.bold),
            ),
            actions: [
              Switch(
                value: weatherProvider.unit == 'metric',
                onChanged: (bool value) {
                  weatherProvider.toggleUnit();
                },
                activeColor: Colors.blueAccent,
                inactiveThumbColor: Colors.orangeAccent,
                inactiveTrackColor: Colors.orange.withOpacity(0.5),
                activeTrackColor: Colors.blue.withOpacity(0.5),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                thumbColor: MaterialStateProperty.all(Colors.white),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _controller,
                  style: TextStyle(
                    fontSize: textsubtitleSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontPMedium,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter city',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          weatherProvider.setCity(_controller.text);
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          // Show a SnackBar with a validation message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a city name.',
                                style: TextStyle(fontFamily: fontPMedium),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    hintStyle: TextStyle(
                      color: Constants.lbl_hint_clr,
                      fontSize: textsubtitleSize,
                      fontWeight: FontWeight.w400,
                      fontFamily: fontPMedium,
                    ),
                    labelStyle: TextStyle(
                      color: Constants.lbl_hint_clr,
                      fontSize: textsubtitleSize,
                      fontWeight: FontWeight.w400,
                      fontFamily: fontPMedium,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: texthintSize,
                      fontFamily: fontPRegular,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.lbl_hint_clr),
                      borderRadius: BorderRadius.circular(
                          15), // Optional: Add rounded corners
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.lbl_hint_clr),
                      borderRadius: BorderRadius.circular(
                          15), // Optional: Add rounded corners
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.lbl_hint_clr),
                      borderRadius: BorderRadius.circular(
                          15), // Optional: Add rounded corners
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(
                          15), // Optional: Add rounded corners
                    ),
                  ),
                ),

                SizedBox(height: 10),
                // Error Message
                if (weatherProvider.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      weatherProvider.errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                if (weatherProvider.currentWeather.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (weatherProvider.isLoading)
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  width: double.infinity,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                                Container(
                                  height: 48,
                                  width: double.infinity,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                                Container(
                                  height: 18,
                                  width: double.infinity,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                                Container(
                                  height: 18,
                                  width: double.infinity,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                ),
                              ],
                            ),
                          )
                        // Actual Weather Data
                        else if (weatherProvider.currentWeather.isNotEmpty)
                          SizedBox(
                              width: double.infinity,
                              child: Card(
                                  color: getRandomLightColor().withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  //elevation: 2,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5),

                                          Text(
                                            '${weatherProvider.currentWeather['name']}, ${weatherProvider.currentWeather['sys']['country']}',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: fontPMedium,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${weatherProvider.currentWeather['main']['temp']}° ${weatherProvider.unit == 'metric' ? 'C' : 'F'}',
                                                style: TextStyle(
                                                  fontSize: 48,
                                                  fontFamily: fontPMedium,
                                                ),
                                              )),
                                          Text(
                                            '${weatherProvider.currentWeather['weather'][0]['description']}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: fontPRegular,
                                            ),
                                          ),
                                          // Add Humidity Display Here
                                          Text(
                                            'Humidity: ${weatherProvider.currentWeather['main']['humidity']}%',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: fontPRegular),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      )))),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                        Text(
                          '3-Day Forecast',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: fontPMedium),
                        ),
                        SizedBox(height: 10),
                        // 3-Day Forecast List
                        Expanded(
                          child: weatherProvider.isLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: ListView.builder(
                                    itemCount:
                                        3, // Show 3 shimmer items for forecast
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: ListTile(
                                          title: Container(
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 15,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                height: 15,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: weatherProvider.forecast.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final forecast =
                                        weatherProvider.forecast[index];
                                    // Parse the date and time
                                    DateTime dateTime =
                                        DateTime.parse(forecast['dt_txt']);
                                    // Format the date and time
                                    String formattedDate =
                                        DateFormat('EEEE, MMM d, y').format(
                                            dateTime); // e.g., "Monday, Jan 1, 2023"
                                    String formattedTime = DateFormat('h:mm a')
                                        .format(dateTime); // e.g., "2:00 PM"

                                    return Card(
                                      color: getRandomLightColor(),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: ListTile(
                                        title: Text(
                                          '$formattedDate at $formattedTime',
                                          style: TextStyle(
                                              fontFamily: fontPMedium,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          'Temp: ${forecast['main']['temp']}° ${weatherProvider.unit == 'metric' ? 'C' : 'F'}\n'
                                          'Condition: ${forecast['weather'][0]['description']}',
                                          style: TextStyle(
                                              fontFamily: fontPMedium,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Future<bool> exit(context) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants1.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: logoutcontentBox(context),
      ),
    );
  }

  logoutcontentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
              left: Constants1.padding,
              top: Constants1.avatarRadius + Constants1.padding,
              right: Constants1.padding,
              bottom: Constants1.padding),
          margin: EdgeInsets.only(top: Constants1.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white,
              //width: 1
            ),
            // boxShadow: [
            //   BoxShadow(color: Colors.black,offset: Offset(0,10),
            //       blurRadius: 10
            //   ),
            // ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Confirmation",
                style: TextStyle(
                    fontSize: 22, fontFamily: fontPBold, color: Colors.black),
              ),
              /*SizedBox(height: 5,),
              Divider(color: Colors.grey,thickness: 0.5,),*/

              SizedBox(
                height: 15,
              ),
              Text(
                "Are you sure, do you want to exit an app?",
                style: TextStyle(
                    fontSize: 17, fontFamily: fontPMedium, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                    },
                    color: Constants.colorPrimary,
                    textColor: Colors.white,
                    child: Icon(Icons.close),
                    padding: EdgeInsets.all(15),
                    shape: CircleBorder(),
                  ),

                  MaterialButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    color: Constants.colorPrimary,
                    textColor: Colors.white,
                    child: Icon(Icons.check),
                    padding: EdgeInsets.all(15),
                    shape: CircleBorder(),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants1.padding,
          right: Constants1.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: Constants1.avatarRadius,
            child: Container(
                decoration: new BoxDecoration(
                  // border: Border.all(
                  //   color: lbl_hint_clr,
                  //   //width: 1
                  // ),
                  //borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                  shape: BoxShape.circle,
                ),
                child:
                    Padding(
                  padding: EdgeInsets.all(0),
                )),
          ),
        ),
      ],
    );
  }
}

class Constants1 {
  Constants1._();
  static const double padding = 30;
  static const double avatarRadius = 45;
}
