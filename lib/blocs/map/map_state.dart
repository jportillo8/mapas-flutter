part of 'map_bloc.dart';

class MapState extends Equatable {
  /*Variables para saber si el mapa esta cargado y
  para seguir o no al usuario*/
  final bool isMapInitialized;
  final bool isFollowingUser;

  /*Mostrar mis rutas*/
  final bool showMyRoute;

  /*Polylines*/
  final Map<String, Polyline> polylines;
  /*mi ruta: {
    id: polylineID Google
    points: [ [lat,lng], [454554,7878], [454554,7878] ]
    width: 3
    color: green
  }*/

  const MapState({
    this.isMapInitialized = false,
    this.isFollowingUser = true,
    this.showMyRoute = true,
    Map<String, Polyline>? polylines,
    /*Si las polylines no se reciben entonces va aser igual una cosnt vacio*/
  }) : polylines = polylines ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        polylines: polylines ?? this.polylines,
      );

  /*Esto para saber si un estado es diferente a otro*/
  @override
  List<Object> get props =>
      [isMapInitialized, isFollowingUser, showMyRoute, polylines];
}
