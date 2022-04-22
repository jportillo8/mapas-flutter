import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

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

  /*Cerrando el Stream*/
  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartMapFollowingUser>(_onStartMapFollowingUser);
    on<OnStopMapFollowingUser>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    /*Polylines*/
    on<UpdateUserPolylinesEvent>(_onPolylineNewPoint);

    on<OnToogleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    /*Vamos a suscribirnos y escuchar lo eventos que el stream nos mande de location*/
    locationStateSubscription = locationBloc.stream.listen((locationState) {
      /*El llamado a al evento lo haremos cuando la pocision cambie, que esta
      dentro de este listener*/
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylinesEvent(locationState.myLocationHistory));
      }

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

  /*Polylines*/
  void _onPolylineNewPoint(
      UpdateUserPolylinesEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    /*Vamos a mandar este polyline al state, creamos una copia de las 
    polylines actuales, por que es una constante y le ponemos la nueva polyline
    y con las nuevas adiciones emitimos un nuevo state*/
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
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

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
