import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/helpers/helpers.dart';
import 'package:maps_flutter_x0/models/models.dart';
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

  /*La siguiente variable la usamos para enviar una posicion final al peticion*/
  LatLng? mapCenter;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartMapFollowingUser>(_onStartMapFollowingUser);
    on<OnStopMapFollowingUser>(
        (event, emit) => emit(state.copyWith(isFollowingUser: false)));

    /*Polylines*/
    on<UpdateUserPolylinesEvent>(_onPolylineNewPoint);

    on<OnToogleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    /*Dibujando las nuevas polylines*/
    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

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

  /*Con este nuevo metodo podremos dibijar las nuevas polylines*/
  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
      polylineId: PolylineId('route'),
      color: Color.fromARGB(255, 114, 234, 105),
      width: 3,
      points: destination.points,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    // Custom Marker
    final startMarkerIcon = await getAssetImage();
    final endMarkerIcon = await getNetworkImage();

    final startMarker = Marker(
        markerId: MarkerId('start'),
        position: destination.points.first,
        icon: startMarkerIcon,
        infoWindow: InfoWindow(
            title: 'Inicio', snippet: 'Kms: $kms, duration: $tripDuration'));
    final endMarker = Marker(
        markerId: MarkerId('end'),
        position: destination.points.last,
        icon: endMarkerIcon,
        infoWindow: InfoWindow(
            title: destination.endPlace.text,
            snippet: destination.endPlace.placeName));

    final currentPolyline = Map<String, Polyline>.from(state.polylines);
    currentPolyline['route'] = myRoute;
    // Markers
    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;
    // Disparando el evento
    add(DisplayPolylinesEvent(currentPolyline, currentMarkers));

    await Future.delayed(const Duration(milliseconds: 300));
    _mapController?.showMarkerInfoWindow(const MarkerId('start'));
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
