import 'package:flutter/material.dart';
import 'package:weather_app/src/utilities/util.dart';

import '../utilities/constant.dart';

class PopupMenu extends StatelessWidget {
  final Function changeUnitsCallback;
  final MasurementUnits unitsSelected;

  const PopupMenu({
    Key? key,
    required this.unitsSelected,
    required this.changeUnitsCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(Icons.settings),
        itemBuilder: ((context) => [
              PopupMenuItem(
                  onTap: null,
                  enabled: false,
                  child: Column(
                    children: const <Widget>[
                      Text(
                        'Unidad de medida',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      Divider(
                        height: 4,
                        thickness: 1.2,
                      )
                    ],
                  )),
              PopupMenuItem(
                  onTap: () {
                    if (unitsSelected == MasurementUnits.celsius) {
                      return;
                    }
                    changeUnitsCallback(MasurementUnits.celsius);
                  },
                  child: Row(
                    children: <Widget>[
                      if (unitsSelected == MasurementUnits.celsius)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      const SizedBox(width: 5),
                      Text(
                        MasurementUnits.celsius.name.capitalize(),
                        style: const TextStyle(),
                      )
                    ],
                  )),
              PopupMenuItem(
                  onTap: () {
                    if (unitsSelected == MasurementUnits.fahrenheit) {
                      return;
                    }
                    changeUnitsCallback(MasurementUnits.fahrenheit);
                  },
                  child: Row(
                    children: <Widget>[
                      if (unitsSelected == MasurementUnits.fahrenheit)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      const SizedBox(width: 5),
                      Text(
                        MasurementUnits.fahrenheit.name.capitalize(),
                        style: const TextStyle(),
                      )
                    ],
                  )),
              PopupMenuItem(
                  onTap: () {
                    if (unitsSelected == MasurementUnits.kelvin) {
                      return;
                    }
                    changeUnitsCallback(MasurementUnits.kelvin);
                  },
                  child: Row(
                    children: <Widget>[
                      if (unitsSelected == MasurementUnits.kelvin)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      const SizedBox(width: 5),
                      Text(
                        MasurementUnits.kelvin.name.capitalize(),
                        style: const TextStyle(),
                      )
                    ],
                  )),
            ]));
  }
}
