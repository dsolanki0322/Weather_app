class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Welcome",
    image: "assets/images/atmospheric-conditions.png",
    desc: "Weather Forecasting Application is one of the most common mini project in Software Development.",
  ),
  OnboardingContents(
    title: "Explore",
    image: "assets/images/weather-forecast.png",
    desc: "In this article, we are going to make a Weather Forecasting Application from scratch which will tell us the weather of any location using its name.",
  ),
  OnboardingContents(
    title: "Get Started",
    image: "assets/images/sun.png",
    desc: "We will be covering all the steps you have to do while developing this mini project. The title of our project will be Today's Weather App.",
  ),
];
