part of 'map_bloc.dart';

class MapState extends Equatable {
  /*Variables para saber si el mapa esta cargado y
  para seguir o no al usuario*/
  final bool isMapInitialized;
  final bool followUser;

  const MapState({this.isMapInitialized = false, this.followUser = false});

  MapState copyWith({
    bool? isMapInitialized,
    bool? followUser,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        followUser: followUser ?? this.followUser,
      );

  /*Esto para saber si un estado es diferente a otro*/
  @override
  List<Object> get props => [isMapInitialized, followUser];
}
