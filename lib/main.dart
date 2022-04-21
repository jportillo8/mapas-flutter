import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/screens/screens.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    BlocProvider(create: (context) => MapBloc()),
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
