import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/weather.dart';
import 'utils/dateUtils.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';


void main() 
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget 
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget 
{
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
  String _cityNameStr = "";
  LocalWeather _weather;
  Color _backgroundColor;
  final String _MyAppId = "PutYourAPIKeyHere";

  Future _initVariables() async
  {
    var myPos = await _getLocation();
    _cityNameStr = await _getCityNameFromLatLng(new Coordinates(myPos.latitude, myPos.longitude));
    _weather = await getWeatherInfo();
    return true;
  }

  Future<LocalWeather> getWeatherInfo() async
  {
    var location = await _getLocation();
    var response = await http.get('https://api.openweathermap.org/data/2.5/onecall?lat='+location.latitude.toString()+'&lon='+location.longitude.toString()+'&exclude=minutely,hourly&&appid='+_MyAppId);
    if (response.statusCode == 200) 
    {
      var jsonString = response.body;
      Map jsonMap = jsonDecode(jsonString);
      var weatherl = LocalWeather.fromJson(jsonMap);
      if(DateTime.now().isAfter(weatherl.current.sunrise) && DateTime.now().isBefore(weatherl.current.sunset))
      {
        if(weatherl.current.weather.first.main == "Clear" || weatherl.current.weather.first.main  == "Clouds")
        {
          _backgroundColor = new Color(0xFF5FABE8);
        }
        else
        {
          _backgroundColor = new Color(0xFF989FB9);
        }
      }
      else
      {
        _backgroundColor = new Color(0xFF0A1D45);
      }
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
      (
        statusBarColor: _backgroundColor,
        systemNavigationBarColor:  _backgroundColor,
      ));
      return weatherl;
    }
    else
    {
      return null;
    }
  }

  Future<String> _getCityNameFromLatLng(Coordinates coordinates) async
  {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return(addresses.first.subAdminArea);
  }

  Future<Position> _getLocation() async 
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return(position);
  }

  Widget build(BuildContext context) 
  {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle
    (
      statusBarColor: _backgroundColor,
      systemNavigationBarColor:  _backgroundColor,
    ));

    return new FutureBuilder
    (
      future: _initVariables(),
      builder: (BuildContext context, AsyncSnapshot snapshot) 
      {
        if(snapshot.hasData)
        {
          return Scaffold
          (
            backgroundColor: _backgroundColor,
            resizeToAvoidBottomInset: false,
            body: Container
            (
              margin: MediaQuery.of(context).padding,
              child: Stack
              (
                children: <Widget>
                [
                  Row
                  (
                    mainAxisAlignment : MainAxisAlignment.center,
                    children: <Widget>
                    [
                      Padding
                      (
                        padding: const EdgeInsets.all(10.0),
                        child: Text
                        (
                          _cityNameStr,
                          style: new TextStyle
                          (
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]
                  ),
                  Padding
                  (
                    padding: const EdgeInsets.fromLTRB(10.0, 40.0, 0, 0),
                    child: Row
                    (
                      mainAxisAlignment : MainAxisAlignment.start,
                      children: <Widget>
                      [
                        Align
                        (
                          alignment: Alignment.topLeft,
                          child: Padding
                          (
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0, 0),
                            child: Text
                            (
                              _weather.current.temperature.toInt().toString(),
                              style: new TextStyle
                              (
                                fontSize: 75.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                        ),
                        Align
                        (
                          alignment: Alignment.topLeft,
                          child: Padding
                          (
                            padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0, 0),
                            child: Text
                            (
                              "ºC",
                              style: new TextStyle
                              (
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding
                  (
                    padding: const EdgeInsets.fromLTRB(30.0, 120.0, 0, 0),
                    child: Text
                    (
                      _weather.current.weather.first.main,
                      style: new TextStyle
                      (
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align
                  (
                    alignment: Alignment.bottomLeft,
                    child: Padding
                    (
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 65.0),
                      child: Container
                      (
                        height: 250,
                        decoration: BoxDecoration
                        (
                          color: new Color(0x33FFFFFF),
          
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding
                        (
                          padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                          child: ListView.builder
                          (
                            padding: EdgeInsets.only(top:30),
                            itemCount: 4,
                            itemBuilder: (context, index) => this._buildForecastRow(index)
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else
        {
          return Scaffold(resizeToAvoidBottomPadding: false, backgroundColor: Colors.white);
        }
      },
    );
  }

  _buildForecastRow(int index) 
  {
    return new Container
    (
      padding: EdgeInsets.only(bottom: 15),
      child: Row
      (
        mainAxisAlignment : MainAxisAlignment.start,
        children: <Widget>
        [
          Image
          (
            //_weather.daily[index].weather.first.icon,
            image: AssetImage
            (
              _weather.daily[index].weather.first.icon,
            ),
            width: 32,
            height: 32,
            
          ),
          Padding
          (
            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Stack
            (
              children: <Widget>
              [
                Text
                (
                  DateUtils.getFormattedDate(_weather.daily[index].date)+" • "+_weather.daily[index].weather.first.main,
                  style: new TextStyle
                  (
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ]
      )
    );
  }

  

}
