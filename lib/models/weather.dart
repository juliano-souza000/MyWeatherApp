class LocalWeather 
{
  double lat;
  double lon;
  String timezone;
  DetailedWeatherCurrent current;
  List<DetailedWeatherDaily> daily = new List<DetailedWeatherDaily>();
  
  LocalWeather.fromJson(Map<String, dynamic> json) 
  {
    this.lat = json['lat'];
    this.lon = json['lon'];
    this.timezone = json['timezone'];
    this.current = DetailedWeatherCurrent.fromJson(json['current']);//
    json['daily'].forEach((weatherl) => this.daily.add(DetailedWeatherDaily.fromJson(weatherl)));
  }
}

class DetailedWeatherCurrent 
{
  DateTime date;
  DateTime sunrise;
  DateTime sunset;
  double temperature;
  double feelsLike;
  double pressure;
  double humidity;
  double uvi;
  double windSpeed;
  List<Weather> weather = new List<Weather>();

  DetailedWeatherCurrent.fromJson(Map<String, dynamic> json) 
  {
    this.date = new DateTime.fromMillisecondsSinceEpoch(json['dt']*1000);
    this.sunrise = new DateTime.fromMillisecondsSinceEpoch(json['sunrise']*1000);
    this.sunset = new DateTime.fromMillisecondsSinceEpoch(json['sunset']*1000);
    this.temperature = double.parse((json['temp'].toDouble()-273.15).toStringAsFixed(2));
    this.feelsLike =  double.parse((json['feels_like'].toDouble()-273.15).toStringAsFixed(2));
    this.pressure = json['pressure'].toDouble();
    this.humidity = json['humidity'].toDouble();
    this.uvi = json['uvi'].toDouble();
    this.windSpeed = json['wind_speed'].toDouble();
    json['weather'].forEach((weatherl) => this.weather.add(Weather.fromJson(weatherl)));
  }
}

class DetailedWeatherDaily
{
  DateTime date;
  DateTime sunrise;
  DateTime sunset;
  TemperatureDaily temperature;
  FeelsLikeDaily feelsLike;
  double pressure;
  double humidity;
  double uvi;
  double windSpeed;
  List<Weather> weather = new List<Weather>();

  DetailedWeatherDaily.fromJson(Map<String, dynamic> json) 
  {
    this.date = new DateTime.fromMillisecondsSinceEpoch(json['dt']*1000);
    this.sunrise = new DateTime.fromMillisecondsSinceEpoch(json['sunrise']*1000);
    this.sunset = new DateTime.fromMillisecondsSinceEpoch(json['sunset']*1000);
    this.temperature = TemperatureDaily.fromJson(json['temp']);
    this.feelsLike = FeelsLikeDaily.fromJson(json['feels_like']);
    this.pressure = json['pressure'].toDouble();
    this.humidity = json['humidity'].toDouble();
    this.uvi = json['uvi'].toDouble();
    this.windSpeed = json['wind_speed'].toDouble();
    json['weather'].forEach((weatherl) => this.weather.add(Weather.fromJson(weatherl)));
  }
}

class TemperatureDaily
{
  double day;
  double min;
  double max;
  double night;
  double evening;
  double morning;

  TemperatureDaily.fromJson(Map<String, dynamic> json) 
  {
    this.day = double.parse((json['day'].toDouble()-273.15).toStringAsFixed(2));
    this.min = double.parse((json['min'].toDouble()-273.15).toStringAsFixed(2));
    this.max = double.parse((json['max'].toDouble()-273.15).toStringAsFixed(2));
    this.night = double.parse((json['night'].toDouble()-273.15).toStringAsFixed(2));
    this.evening =  double.parse((json['eve'].toDouble()-273.15).toStringAsFixed(2));
    this.morning = double.parse((json['morn'].toDouble()-273.15).toStringAsFixed(2));
  }
}

class FeelsLikeDaily
{
  double day;
  double night;
  double evening;
  double morning;

  FeelsLikeDaily.fromJson(Map<String, dynamic> json) 
  {
    this.day = double.parse((json['day'].toDouble()-273.15).toStringAsFixed(2));
    this.night = double.parse((json['night'].toDouble()-273.15).toStringAsFixed(2));
    this.evening =  double.parse((json['eve'].toDouble()-273.15).toStringAsFixed(2));
    this.morning = double.parse((json['morn'].toDouble()-273.15).toStringAsFixed(2));
  }
}

class Weather 
{
  int id;
  String main;
  String description;
  String icon;
  Weather.fromJson(Map<String, dynamic> json) 
  {
    this.id = json['id'];
    this.main = json['main'];
    if(this.main == "Mist")
    {
      this.main = "Foggy";
    }
    this.description = json['description'];
    this.icon =  _getLocalIconPath(json['icon']);
  }

  String _getLocalIconPath(String icon)
  {
    if(icon == "03n")
    {
      icon = "03d";
    }
    else if( icon == "04d")
    {
      icon = "02d";
    }
    else if(icon == "04n")
    {
      icon = "02n";
    }
    else if(icon == "09n")
    {
      icon = "09d";
    }
    else if(icon == "10n")
    {
      icon = "10d";
    }
    else if(icon == "11n")
    {
      icon = "11d";
    }
    else if(icon == "13n")
    {
      icon = "13d";
    }
    else if(icon == "50n")
    {
      icon = "50d";
    }
    return "resources/weather/"+icon+".webp";
  }
  //set setIcon(String icon) => _icon = "http://openweathermap.org/img/w/" + icon + ".png";
}