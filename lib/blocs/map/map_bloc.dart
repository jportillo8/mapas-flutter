import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter_x0/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  /*Implementaremos un controlador para definir el comportamiento del mapa*/
  GoogleMapController? _mapController;

  MapBloc() : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap);
  }

  /*Implementaremos un controlador para definir el comportamiento del mapa*/
  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    /*Toda esa configuracion que no entendi para poder
    cambiar el estilo al mapa que nivel por Dios!!!*/
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));

    emit(state.copyWith(isMapInitialized: true));
  }
}
