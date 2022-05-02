import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/screens/screens.dart';
import 'package:maps_flutter_x0/services/services.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    /*Para crear la depencia ya definimos el bloc, y debemos pasarle lo datos
    requeridos, mediante el contexto instaciado con los anteriores blocs*/
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
    BlocProvider(
        /*De esta forma este bloc ya tiene acceso a cualquier propieda o metodo
      de TrafficService*/
        create: (context) => SearchBloc(trafficService: TrafficService()))
  ], child: const MapsApp()));
}

class MapsApp extends StatelessWidget {
  const MapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Maps App',
        home: LoadingScreen());
  }
}
