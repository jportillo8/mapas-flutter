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
