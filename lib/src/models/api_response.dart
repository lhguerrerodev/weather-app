import 'dart:convert';

import 'package:weather_app/src/models/weather_response.dart';

class ApiResponse {
  bool success = false;
  String error = '';
  String message = '';
  Map<String, dynamic> data = {};
  WeatherResponse? weatherResponse;

  ApiResponse();

  ApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    error = json['error'] ?? '';
    message = json['message'] ?? '';
    data = json['data'] != null && json['data']!.toString().isNotEmpty
        ? jsonDecode(jsonEncode(json['data']))
        : {};
  }
}
