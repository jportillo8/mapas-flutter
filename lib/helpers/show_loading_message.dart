import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*Este loading lo mandaremos cuando se este creando el tarzo de
de linea*/
void showLoadingMessage(BuildContext context) {
  // Android:
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: const Text('Espere por favor'),
            content: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 10),
              child: Column(children: const [
                Text('Calculando ruta'),
                SizedBox(height: 15),
                CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
              ]),
            )));
    return;
  }
  showCupertinoDialog(
      context: context,
      builder: (context) => const CupertinoAlertDialog(
            title: Text('Espere por favor'),
            content: CupertinoActivityIndicator(),
          ));
}
