import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

const apiKey = "4a3e1f5e3fd0d471f0284a75030a92e8";

class Capitals {
  String _name;
  double _temperature;
  Icon _icon;

  Capitals(String name, double temperature, Icon icon) {
    this._name = name;
    this._temperature = temperature;
    this._icon = icon;
  }
  get name {
    return _name;
  }

  get temperature {
    return _temperature;
  }

  get icon {
    return _icon;
  }
}

class CapitalsData {
  List<String> capitalsName = [
    "ankara",
    "londra",
    "washington",
    "berlin",
    "tokyo",
    "seul",
    "madrid",
    "roma",
    "paris",
    "islamabad",
    "pekin",
    "bakü"
  ];
  Capitals capital;
  double currentTemperature;
  int currentCondition;
  String city;
  Icon icon;
  List<Widget> capitalsWidgets = <Widget>[];
  Future<void> getCurrentTemperature() async {
    for (int i = 0; i < capitalsName.length; i++) {
      Response response = await get(
          "https://api.openweathermap.org/data/2.5/weather?q=${capitalsName[i]}&appid=${apiKey}&units=metric");

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
      var now = new DateTime.now();
      //saat 19:00 dan önce ise iconlar sabah saatine göre ayarlanacak..
      if (now.hour < 19) {
        //hava az yağmurlu ise
        if (currentCondition < 500) {
          icon = Icon(FontAwesomeIcons.cloudSunRain,
              size: 20.0, color: Colors.yellow[100]);
        }
        //hava yağmurlu ise..
        else if (currentCondition < 600) {
          icon = Icon(FontAwesomeIcons.cloudShowersHeavy,
              size: 20.0, color: Colors.blue[100]);
        }
        //hava karlı ise..
        else if (currentCondition < 700) {
          icon = Icon(Icons.cloudy_snowing, size: 20.0, color: Colors.white);
        }
        //hava iyi ise..
        else if (currentCondition <= 800) {
          icon =
              Icon(FontAwesomeIcons.sun, size: 20.0, color: Colors.yellow[300]);
        }
        //hava bulutlu ise..
        else if (currentCondition > 800) {
          icon = Icon(FontAwesomeIcons.cloud, size: 20.0, color: Colors.white);
        }
      } //saat 19:00 dan sonra ise iconlar akşam saatine göre ayarlanacak..
      else {
        //hava az yağmurlu ise
        if (currentCondition < 500) {
          icon = Icon(FontAwesomeIcons.cloudMoonRain,
              size: 20.0, color: Colors.grey[300]);
        }
        //hava yağmurlu ise..
        else if (currentCondition < 600) {
          icon = Icon(FontAwesomeIcons.cloudShowersHeavy,
              size: 20.0, color: Colors.blueGrey[300]);
        }
        //hava karlı ise..
        else if (currentCondition < 700) {
          icon = Icon(Icons.cloudy_snowing, size: 20.0, color: Colors.white);
        }
        //hava iyi ise..
        else if (currentCondition <= 800) {
          icon = Icon(FontAwesomeIcons.moon,
              size: 20.0, color: Colors.yellow[300]);
        }
        //hava bulutlu ise..
        else if (currentCondition > 800) {
          icon = Icon(FontAwesomeIcons.cloudMoon,
              size: 20.0, color: Colors.grey[300]);
        }
      }
      //verileri oluşturduğumuz capital nesnesine atıyoruz..
      capital = Capitals(city, currentTemperature, icon);
      capitalsWidgets.add(getCapitalsWidget(capital));
    }
  }

  //Kendi oluşturduğumuz Widget listesinin icerine Widgetlar eklemek istiyoruz
  // bu Widgetların içerisinde ulkeler hakkında bilgiler bulunacak
  Widget getCapitalsWidget(Capitals capital) {
    return Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            capital.icon,
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              capital.temperature.round().toString() + "°",
              style: TextStyle(fontSize: 25),
            )),
            SizedBox(
              height: 10,
            ),
            Text(
              capital.name,
              style: TextStyle(fontSize: 15.0),
            )
          ],
        ));
  }
}
