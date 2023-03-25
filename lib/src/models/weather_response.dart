import 'dart:convert';

class WeatherResponse {
    WeatherResponse({
        required this.weather,
        required this.main,
        required this.name,
        required this.cod,
    });

    List<Weather> weather;
    Main main;
    String name;
    int cod;

    factory WeatherResponse.fromRawJson(String str) => WeatherResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WeatherResponse.fromJson(Map<String, dynamic> json) => WeatherResponse(
        weather: List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        main: Main.fromJson(json["main"]),
        name: json["name"],
        cod: json["cod"],
    );

    Map<String, dynamic> toJson() => {
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "main": main.toJson(),
        "name": name,
        "cod": cod,
    };
}

class Main {
    Main({
        required this.temp,
        required this.feelsLike,
        required this.tempMin,
        required this.tempMax,
        required this.pressure,
        required this.humidity,
        required this.seaLevel,
        required this.grndLevel,
    });

    double temp;
    double feelsLike;
    double tempMin;
    double tempMax;
    int pressure;
    int humidity;
    int seaLevel;
    int grndLevel;

    factory Main.fromRawJson(String str) => Main.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"]?.toDouble(),
        feelsLike: json["feels_like"]?.toDouble(),
        tempMin: json["temp_min"]?.toDouble(),
        tempMax: json["temp_max"]?.toDouble(),
        pressure: json["pressure"]??0,
        humidity: json["humidity"]??0,
        seaLevel: json["sea_level"]??0,
        grndLevel: json["grnd_level"]??0,
    );

    Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "humidity": humidity,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
    };
}

class Weather {
    Weather({
        required this.id,
        required this.main,
        required this.description,
        required this.icon,
    });

    int id;
    String main;
    String description;
    String icon;

    factory Weather.fromRawJson(String str) => Weather.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
    };
}
