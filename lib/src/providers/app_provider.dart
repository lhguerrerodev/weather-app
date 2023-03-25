import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:weather_app/src/services/api_service.dart';
import 'package:weather_app/src/utilities/constant.dart';

import '../models/api_response.dart';
import '../models/weather_response.dart';
import '../services/location_service.dart';

class AppProvider with ChangeNotifier {
  TextEditingController searchTxtCtrl = TextEditingController();

  LocationService locationService = LocationService();
  ApiService apiService = ApiService();

  MasurementUnits masurementUnit = MasurementUnits.kelvin;

  bool initializedHome = false;

  WeatherResponse? currentLocationWeather;

  WeatherResponse? searchedWeather; 

  List<WeatherResponse> savedCities = [];

  List<dynamic> savedCityNames = [];

  bool loading = false;


  AppProvider() {
    apiService.init();
  }

  Future<String> initHomePage() async {
    if (initializedHome) return '';

    currentLocationWeather = null;

    await locationService.getCurrentPosition();

     String unit =  GetStorage().read('unit') ?? '';

    if(unit == MasurementUnits.fahrenheit.name){
       masurementUnit = MasurementUnits.fahrenheit;
    } else if(unit == MasurementUnits.kelvin.name){
       masurementUnit = MasurementUnits.kelvin;
    } else {
       masurementUnit = MasurementUnits.celsius;
    }

    if (locationService.currentPosition != null) {
      ApiResponse response = await apiService.getWeatherByPosition(
          locationService.currentPosition!.latitude,
          locationService.currentPosition!.longitude,
          masurementUnit);

      if (response.success) {
        currentLocationWeather = response.weatherResponse;
      }

    }

     savedCityNames = GetStorage().read('cities') ?? [];

     await geCitiesWeather();

    initializedHome = true;
    loading = false;

    return '';
  }


  refresh(){
    loading = true;
    initializedHome = false;
    currentLocationWeather = null;
    savedCities = [];
    notifyListeners();
  }
  getLocationWeather() async {
    if (locationService.currentPosition != null) {
      ApiResponse response = await apiService.getWeatherByPosition(
          locationService.currentPosition!.latitude,
          locationService.currentPosition!.longitude,
          masurementUnit);

      if (response.success) {
        currentLocationWeather = response.weatherResponse;
      }

    }

  }
  

  Future<String> geCityWeather() async {
      ApiResponse response = await apiService.getWeatherByCity(
          searchTxtCtrl.text.trim(),
          masurementUnit);

      if (response.success) {
        searchedWeather = response.weatherResponse;
      } else {
        return response.error;
      }

      return '';

  }

  addCity(){
    if(searchedWeather != null) {

      if(savedCityNames.contains(searchedWeather!.name)) return;



      savedCities.add(searchedWeather!);
      savedCityNames.add(searchedWeather!.name);
      GetStorage().write('cities', savedCityNames);
      notifyListeners();
    }
  }

  deleteCity(String city){

    savedCityNames.remove(city);

    savedCities.removeWhere( (item) => item.name == city );

     GetStorage().write('cities', savedCityNames);

      notifyListeners();
  
  }

  Future<void> geCitiesWeather() async {

    

    List<WeatherResponse> listResponse = [];
    for (var city in savedCityNames) {
      ApiResponse response = await apiService.getWeatherByCity(
          city,
          masurementUnit);

      if (response.success) {
        listResponse.add(response.weatherResponse!);
      } 
     }

     savedCities = listResponse;
  }

  changeUnitMetrics(MasurementUnits unit) async {
    loading = true;
    notifyListeners();
    masurementUnit = unit;

    GetStorage().write('unit', unit.name);

    await getLocationWeather();

    await geCitiesWeather();

    loading = false;

    notifyListeners();



  }
}
