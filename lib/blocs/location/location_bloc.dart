import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;

  LocationBloc() : super(const LocationState()) {
    on<LocationEvent>((event, emit) {});
  }

  Future getCurrentPosition() async {
    /*Esto me determina la posicion actual de el user*/
    final position = await Geolocator.getCurrentPosition();
    print('Position: $position');
    // TODO retornar un objeto de tipo LatLng
  }

  void starFollowingUser() {
    print('starFollowingUser');
    /*Se activa cada vez que la ubicación cambia dentro
     de los límites de [LocationSettings.accuracy] proporcionado.
     Este evento inicia todos los sensores de ubicación en el 
     dispositivo y los mantendrá activos hasta que cancele la 
     escucha de la transmisión o cuando se elimine la aplicación.*/
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      print('Posicion: $position');
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    print('stopFollowingUser');
  }

  @override
  Future<void> close() {
    starFollowingUser();
    return super.close();
  }
}
