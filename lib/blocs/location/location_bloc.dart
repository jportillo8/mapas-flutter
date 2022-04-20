import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;

  LocationBloc() : super(const LocationState()) {
    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
        lastKnowLocation: event.newLocation,
        // Esparce todo lo que viene en el arreglo y añade el ultimo
        myLocationHistory: [...state.myLocationHistory, event.newLocation],
      ));
    });
  }

  Future getCurrentPosition() async {
    /*Esto me determina la posicion actual de el user*/
    final position = await Geolocator.getCurrentPosition();
    // print('Position: $position');
    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void starFollowingUser() {
    // print('starFollowingUser');
    /*Se activa cada vez que la ubicación cambia dentro
     de los límites de [LocationSettings.accuracy] proporcionado.
     Este evento inicia todos los sensores de ubicación en el 
     dispositivo y los mantendrá activos hasta que cancele la 
     escucha de la transmisión o cuando se elimine la aplicación.*/
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
      // print('Posicion: $position');
    });
  }

  /*Esta funcion me permite cerrar el Stream para no tener
  fugas de memoria*/
  void stopFollowingUser() {
    positionStream?.cancel();
    print('stopFollowingUser');
  }

  /*Esta funcion me permite cerrar el Stream para no tener
  fugas de memoria*/
  @override
  Future<void> close() {
    starFollowingUser();
    return super.close();
  }
}
