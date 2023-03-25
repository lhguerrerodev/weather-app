import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weather_app/src/utilities/constant.dart';

import '../models/api_response.dart';
import '../models/weather_response.dart';

class ApiService {
  // Singleton
  late Dio _dio;
  static ApiService? _intance;

  ApiService._();

  factory ApiService() => _intance ??= ApiService._();

  init() async {
    _dio = Dio(BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 1),
    ));
  }

  Future<ApiResponse> getWeatherByPosition(
      double lat, double lon, MasurementUnits masurementUnit) async {
    late Response responseHttp;
    ApiResponse response = ApiResponse();
    try {
      String units = '';

      switch (masurementUnit) {
        case MasurementUnits.celsius:
          units = 'metric';
          break;
        case MasurementUnits.fahrenheit:
          units = 'imperial';
          break;
        case MasurementUnits.kelvin:
          units = 'standard';
          break;
      }

      responseHttp = await _dio.get(
          '$endPointUrl/weather?lat=$lat&appid=$apiKey&units=$units&lang=sp&lon=$lon');

      if (responseHttp.statusCode == 200) {
        response.success = true;
        response.weatherResponse =
            WeatherResponse.fromRawJson(jsonEncode(responseHttp.data));
      }
    } on DioError catch (ex) {
      return _handleError(ex);
    }

    return response;
  }

  Future<ApiResponse> getWeatherByCity(
      String city, MasurementUnits masurementUnit) async {
    late Response responseHttp;
    ApiResponse response = ApiResponse();
    try {
      String units = '';

      switch (masurementUnit) {
        case MasurementUnits.celsius:
          units = 'metric';
          break;
        case MasurementUnits.fahrenheit:
          units = 'imperial';
          break;
        case MasurementUnits.kelvin:
          units = 'standard';
          break;
      }

      responseHttp = await _dio.get(
          '$endPointUrl/weather?q=$city&appid=$apiKey&units=$units&lang=sp');

      if (responseHttp.statusCode == 200) {
        response.success = true;
        response.weatherResponse =
            WeatherResponse.fromRawJson(jsonEncode(responseHttp.data));
      }
    } on DioError catch (ex) {
      return _handleError(ex);
    }
    return response;
  }

  ApiResponse _handleError(DioError ex) {
    ApiResponse response = ApiResponse();
    if (DioErrorType.receiveTimeout == ex.type ||
        DioErrorType.connectionTimeout == ex.type) {
      response.error = 'Error de conexión';
    } else if (DioErrorType.badResponse == ex.type) {
      if (ex.response!.statusCode == 404) {
        response.error = "Sin resultados de la búsqueda";
      }
      if (ex.response!.statusCode == 400) {
        response.error = "Error 400 Bad request";
      }
    } else if (DioErrorType.unknown == ex.type) {
      response.error = 'Error al conectarse con el servidor';
    } else {
      response.error = "Error al conectarse con el servidor";
    }
    response.success = false;
    response.message = 'Error al conectar con el servidor, intentelo más tarde';
    return response;
  }
}
