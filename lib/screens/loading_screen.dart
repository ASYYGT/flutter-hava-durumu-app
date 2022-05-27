import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hava_durumu_app_v1/screens/main_screen.dart';
import 'package:hava_durumu_app_v1/utils/location.dart';
import 'package:hava_durumu_app_v1/utils/weather.dart';
import 'package:hava_durumu_app_v1/utils/capitals.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LocationHelper locationData;
  Future<void> getLocationData() async {
    locationData = LocationHelper();
    await locationData.getCurrentLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      print("Konum bilgileri gelmiyor.");
    } else {
      print("latitude: " + locationData.latitude.toString());
      print("longitude: " + locationData.longitude.toString());
    }
  }

  void getWeatherData() async {
    await getLocationData();

    WeatherData weatherData = WeatherData(locationData: locationData);
    CapitalsData capitalsData = CapitalsData();
    await capitalsData.getCurrentTemperature();
    await weatherData.getCurrentTemperature();
    if (weatherData.currentTemperature == null ||
        weatherData.currentCondition == null) {
      print("API den sıcaklık veya durum bilgisi boş dönüyor.");
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainScreen(weatherData: weatherData, capitalsData: capitalsData);
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.1,
                0.3,
                0.5,
                0.7,
                0.9
              ],
              colors: [
                Color(0xFFE2FDFF),
                Color(0xFFBFD7FF),
                Color(0xFF9BB1FF),
                Color(0xFF788BFF),
                Color(0xFF5465FF)
              ]),
        ),
        child: Center(
          child: SpinKitSpinningLines(
            color: Colors.yellow[300],
            size: 150.0,
            duration: Duration(milliseconds: 3000),
          ),
        ),
      ),
    );
  }
}
