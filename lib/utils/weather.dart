import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'location.dart';

const apiKey = "4a3e1f5e3fd0d471f0284a75030a92e8";

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({@required this.weatherIcon, this.weatherImage});
}

class WeatherData {
  WeatherData({@required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentCondition;
  String city;

  Future<void> getCurrentTemperature() async {
    Response response = await get(
        "http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric");

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        city = currentWeather['name'];
      } catch (e) {
        print(e);
      }
    } else {
      print("API den değer gelmiyor!");
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    var now = new DateTime.now();
    //saat 19:00 dan önce ise icon ve arkaplan resmi sabah saatine göre ayarlanacak..
    if (now.hour < 19) {
      if (currentCondition < 500) {
        //hava az yağmurlu ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.cloudSunRain,
                size: 75.0, color: Colors.yellow[100]),
            weatherImage: AssetImage('assets/yagmur_gunduz.png'));
      }
      if (currentCondition < 600) {
        //hava yağmurlu ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.cloudShowersHeavy,
                size: 75.0, color: Colors.blue[100]),
            weatherImage: AssetImage('assets/yagmur_gunduz.png'));
      }
      if (currentCondition < 700) {
        //hava karlı ise
        return WeatherDisplayData(
            weatherIcon:
                Icon(Icons.cloudy_snowing, size: 75.0, color: Colors.white),
            weatherImage: AssetImage('assets/kar_gunduz.png'));
      }
      if (currentCondition <= 800) {
        //hava açık ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.sun,
                size: 75.0, color: Colors.yellow[300]),
            weatherImage: AssetImage('assets/gunesli.png'));
      }
      if (currentCondition > 800) {
        //hava bulutlu ise
        return WeatherDisplayData(
            weatherIcon:
                Icon(FontAwesomeIcons.cloud, size: 75.0, color: Colors.white),
            weatherImage: AssetImage('assets/bulutlu.png'));
      }
    } //end if..
    //saat 19:00 dan sonra ise icon ve arkaplan resmi akşam saatine göre ayarlanacak..
    else {
      if (currentCondition < 500) {
        //hava az yağmurlu ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.cloudMoonRain,
                size: 75.0, color: Colors.grey[300]),
            weatherImage: AssetImage('assets/yagmur_gece.png'));
      }
      if (currentCondition < 600) {
        //hava yağmurlu ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.cloudShowersHeavy,
                size: 75.0, color: Colors.blueGrey[300]),
            weatherImage: AssetImage('assets/yagmur_gece.png'));
      }
      if (currentCondition < 700) {
        //hava karlı ise
        return WeatherDisplayData(
            weatherIcon:
                Icon(Icons.cloudy_snowing, size: 75.0, color: Colors.white),
            weatherImage: AssetImage('assets/kar_gece.png'));
      }
      if (currentCondition <= 800) {
        //hava açık ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.moon,
                size: 75.0, color: Colors.yellow[300]),
            weatherImage: AssetImage('assets/gece.png'));
      }
      if (currentCondition > 800) {
        //hava bulutlu ise
        return WeatherDisplayData(
            weatherIcon: Icon(FontAwesomeIcons.cloudMoon,
                size: 75.0, color: Colors.grey[300]),
            weatherImage: AssetImage('assets/bulutlu_gece.png'));
      }
    }
  }
}
