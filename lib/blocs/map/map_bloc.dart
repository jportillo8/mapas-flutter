import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  /*Con el fin crear polylines y se seguir al usuario con la camara
  y asi crear depencia entre dos blocks*/
  final LocationBloc locationBloc;

  /*Implementaremos un controlador para definir el comportamiento del mapa*/
  GoogleMapController? _mapController;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartMapFollowingUser>(_onStartMapFollowingUser);
    on<OnStopMapFollowingUser>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    /*Vamos a suscribirnos y escuchar lo eventos que el stream nos mande de location*/
    locationBloc.stream.listen((locationState) {
      /*Si la app no esta en seguimiento entoces no haremos nada*/
      if (!state.isFollowingUser) return;
      /*Entonces si no tenemos la ultima ubicacion tampoco podemos hacer nada*/
      if (locationState.lastKnowLocation == null) return;
      /*Por lo tanto podemos mover la camara constantemente con por el listen*/
      movecamera(locationState.lastKnowLocation!);
    });
  }

  /*Implementaremos un controlador para definir el comportamiento del mapa*/
  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    /*Toda esa configuracion que no entendi para poder
    cambiar el estilo al mapa que nivel por Dios!!!*/
    _mapController!.setMapStyle(jsonEncode(uberMapThemeLight));

    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartMapFollowingUser(
      OnStartMapFollowingUser event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnowLocation == null) return;
    movecamera(locationBloc.state.lastKnowLocation!);
  }

  void movecamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }
}
