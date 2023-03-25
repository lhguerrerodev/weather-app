import 'package:flutter/material.dart';

import 'constant.dart';

class Util {

  static const double padding = 20;
  static const double avatarRadius = 45;

  static Future<void> alertDialog(
      {String title = '',
      String msj = '',
      required String tipo,
      String okText = '',
      Function? okFunc,
      required BuildContext context}) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black38,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future(() => false);
              },
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padding),
                ),
                elevation: 50,
                backgroundColor: Colors.transparent,
                child: contentBox2(title, msj, tipo, okText, okFunc, context),
              ));
        });
  }

  static contentBox2(String title, String msj, String tipo, String okText,
      Function? okFunc, context) {
    Icon? icon;
    bool confirm = false;
    bool loading = false;
    switch (tipo) {
      case 'Success':
        icon = const Icon(Icons.done, size: 50, color: Colors.white);
        break;
      case 'Warning':
        icon = const Icon(Icons.priority_high, size: 50, color: Colors.white);
        break;
      case 'Error':
        icon = const Icon(Icons.priority_high, size: 50, color: Colors.white);
        break;
      case 'Confirm':
        confirm = true;
        break;
      default:
        loading = true;
        break;
    }
    return Stack(children: <Widget>[
      Container(
          padding: const EdgeInsets.only(
              left: padding,
              top: (avatarRadius / 2) + 10 + padding,
              right: padding,
              bottom: 10),
          margin: const EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white.withOpacity(1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(),
            if (title.isNotEmpty)
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      color: cPColor,
                      fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            if (!loading)
              SizedBox(
                  width: double.infinity,
                  child: Text(msj,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      textAlign: msj.length > 80
                          ? TextAlign.justify
                          : TextAlign.center,
                      style: const TextStyle(fontSize: 17, color: cPColor))),
            if (!loading && !confirm)
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      okText.isNotEmpty ? okText : 'Ok',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (okFunc != null) {
                        okFunc();
                      }
                    })
              ]),
            if (confirm || loading) const SizedBox(height: 10),
            if (confirm)
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Text(
                      okText.isNotEmpty ? okText : 'Aceptar',
                      style: const TextStyle(
                          color: cPColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      okFunc!();
                    })
              ])
          ])),
      Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: cPColor,
            radius: avatarRadius,
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 3,
                    backgroundColor: cPColor,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : confirm
                    ? const Text("?",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            color: Colors.white))
                    : icon,
          ))
    ]);
  }

  
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}