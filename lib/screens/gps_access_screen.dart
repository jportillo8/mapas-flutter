import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_flutter_x0/blocs/blocks.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          // print('state: $state');
          return !state.isGpsEnable
              ? const _EnableGpsMessage()
              : const _AccessButton();
        },
      )),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso al GPS',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        MaterialButton(
            color: Colors.black54,
            shape: StadiumBorder(),
            elevation: 0,
            splashColor: Color.fromARGB(255, 7, 255, 98),
            child: const Text('Solicitar Acceso',
                style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              // final gspBloc = context.read<GpsBloc>();
              gpsBloc.askGpsAcces();
            })
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Debes habilitar el GPS',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w300, fontSize: 25));
  }
}
