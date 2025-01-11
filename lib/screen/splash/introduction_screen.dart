import 'package:flutter/material.dart';
import 'package:new_weather/config/utils/constant.dart';
import 'package:new_weather/screen/weather/weather_screen.dart';
import 'onboarding_contents.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<IntroductionScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  List colors = [Color(0xffDAD3C8), Color(0xffFFE5DE), Color(0xffDCF6E6)];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Container(
                    // color: colors[i],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 22),
                      child: Column(
                        children: [

                          Image.asset(
                            contents[i].image,
                            height: SizeConfig.blockV! * 35,
                          ),
                          SizedBox(
                            height: (height >= 840) ? 50 : 20,
                          ),
                          Text(
                            contents[i].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: fontPMedium,
                              fontWeight: FontWeight.w600,
                              //fontWeight: FontWeight.bold,
                              fontSize: (width <= 550) ? 25 : 30,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            contents[i].desc,
                            style: TextStyle(
                              fontFamily: fontPMedium,
                              fontWeight: FontWeight.w300,
                              fontSize: (width <= 550) ? 15 : 20,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                          (int index) => _buildDots(index: index),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WeatherScreen()));
                      },
                      child: Text("START",style: TextStyle(fontFamily: fontPRegular),),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:  Constants.colorPrimary,
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: (width <= 550)
                            ? EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)
                            : EdgeInsets.symmetric(
                            horizontal: width * 0.2, vertical: 25),
                        textStyle:
                        TextStyle(fontSize: (width <= 550) ? 15 : 17),
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _controller.jumpToPage(2);
                          },
                          child: Text(
                            "SKIP",
                            style: TextStyle(color: Colors.black,fontFamily: fontPRegular),
                          ),
                          style: TextButton.styleFrom(
                            elevation: 0,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: (width <= 550) ? 15 : 17,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Text("NEXT",style: TextStyle(fontFamily: fontPRegular),),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:  Constants.colorPrimary,
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                            padding: (width <= 550)
                                ? EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20)
                                : EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            textStyle: TextStyle(fontSize: (width <= 550) ? 15 : 17),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}

