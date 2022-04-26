part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent {
  /*Este controlador es que va generar el mapa*/
  final GoogleMapController controller;

  const OnMapInitializedEvent(this.controller);
}

class OnStopMapFollowingUser extends MapEvent {}

class OnStartMapFollowingUser extends MapEvent {}

/*Polylines*/
class UpdateUserPolylinesEvent extends MapEvent {
  // Historial de ubicaciones.
  final List<LatLng> userLocations;
  const UpdateUserPolylinesEvent(this.userLocations);
}

class OnToogleUserRoute extends MapEvent {}

/*Este evento es para el manejo de el dibujo de las polylines*/
class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;

  const DisplayPolylinesEvent(this.polylines);
}
