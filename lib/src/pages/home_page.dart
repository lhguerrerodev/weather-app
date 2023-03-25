import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/src/models/weather_response.dart';
import 'package:weather_app/src/providers/app_provider.dart';
import 'package:weather_app/src/utilities/constant.dart';

import '../utilities/util.dart';
import '../widgets/popup_menu.dart';

class HomePage extends StatelessWidget {
  static const id = 'home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color.fromARGB(255, 1, 255, 22),
              Color.fromARGB(255, 45, 167, 94),
              Color.fromARGB(255, 17, 65, 37),
              Color.fromARGB(255, 0, 0, 0),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(child: _initPage(context)),
      ),
    );
  }

  _initPage(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return FutureBuilder<String>(
        future: appProvider.initHomePage(),
        builder: (_, snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return _body(context);
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              const SizedBox(
                width: 190,
                height: 190,
                child: Opacity(
                  opacity: 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: Colors.white,
                  ),
                ),
              ),
            ];
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        });
  }

  _body(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _appBar(context),
        _searchBar(context),
        if (!appProvider.locationService.locationEabled && !appProvider.loading)
          ..._settingsBtn(context),
        if (appProvider.currentLocationWeather != null)
          _locationWeatherCard(context),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              for (var weather in appProvider.savedCities)
                _cityWeatherCard(context, weather)
            ],
          ),
        ))
      ],
    );
  }

  _appBar(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Clima",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40)),
        Expanded(child: Container()),
        if (appProvider.loading)
          const CircularProgressIndicator(
            color: Colors.white,
          )
        else
          GestureDetector(
            onTap: () {
              appProvider.refresh();
            },
            child: const Icon(
              Icons.refresh,
              size: 28,
            ),
          ),
        if (!appProvider.loading)
          PopupMenu(
            unitsSelected: appProvider.masurementUnit,
            changeUnitsCallback: (val) async {
              await appProvider.changeUnitMetrics(val);
            },
          ),
      ],
    );
  }

  _searchBar(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return AnimSearchBar(
      helpText: "Buscar ciudad",
      width: 400,
      color: Colors.black,
      textController: appProvider.searchTxtCtrl,
      searchIconColor: Colors.white,
      suffixIcon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      onSuffixTap: () {},
      onSubmitted: (val) async {
        if (appProvider.searchTxtCtrl.text.isEmpty) return;
        Util.alertDialog(
          tipo: 'Loading',
          title: 'Cargando...',
          msj: '',
          context: context,
        );

        String response = await appProvider.geCityWeather();

        Navigator.pop(context);

        if (response.isNotEmpty) {
          await Util.alertDialog(
              tipo: 'Error',
              title: 'Aviso',
              msj: response,
              context: context,
              okFunc: () {});
        } else {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              backgroundColor: Colors.black,
              builder: (context) {
                return _bodyModal(context);
              });
        }
      },
    );
  }

  _bodyModal(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      appProvider.addCity();
                    },
                    child: const Text("Agregar"))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(appProvider.searchedWeather!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 33))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${appProvider.searchedWeather!.main.temp}°",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 45))
              ],
            ),
            Image.network(
                "$baseURL/img/w/${appProvider.searchedWeather!.weather[0].icon}.png"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    appProvider.searchedWeather!.weather[0].description
                        .capitalize(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 25))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Mín: ${appProvider.searchedWeather!.main.tempMin}° Máx: ${appProvider.searchedWeather!.main.tempMax}°",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 25))
              ],
            ),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }

  _settingsBtn(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            elevation: 10,
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              onTap: () async {
                appProvider.initializedHome = false;
                await Geolocator.openLocationSettings();
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  alignment: Alignment.center,
                  child: const Text(
                    "Activar ubicación",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 10,
      )
    ];
  }

  _locationWeatherCard(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Card(
      color: Colors.black38,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(height: 10),
                    /*const Text("Mi ubicación",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20)),*/
                    Text(appProvider.currentLocationWeather!.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 18))
                  ],
                )),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${appProvider.currentLocationWeather!.main.temp}°",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 35)),
                  ],
                )),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                        "$baseURL/img/w/${appProvider.currentLocationWeather!.weather[0].icon}.png"),
                    Text(
                        appProvider
                            .currentLocationWeather!.weather[0].description
                            .capitalize(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 14)),
                  ],
                )),
                Expanded(
                    child: Text(
                        "Mín: ${appProvider.currentLocationWeather!.main.tempMin}° Máx: ${appProvider.currentLocationWeather!.main.tempMax}°",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 13))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _cityWeatherCard(BuildContext context, WeatherResponse weather) {
    final appProvider = Provider.of<AppProvider>(context);
    return Card(
      color: Colors.black38,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(weather.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20))),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${weather.main.temp}°",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 35)),
                    GestureDetector(
                      onTap: () {
                        Util.alertDialog(
                            tipo: 'Confirm',
                            title: 'Eliminar ${weather.name}',
                            msj: '¿Desea eliminar elemento de la lista? ',
                            context: context,
                            okFunc: () {
                              appProvider.deleteCity(weather.name);
                            });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red.withOpacity(0.7),
                        size: 35,
                      ),
                    )
                  ],
                )),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                        "$baseURL/img/w/${weather.weather[0].icon}.png"),
                    Text(weather.weather[0].description.capitalize(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 14)),
                  ],
                )),
                Expanded(
                    child: Text(
                        "Mín: ${weather.main.tempMin}° Máx: ${weather.main.tempMax}°",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 13))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
