part of 'map_bloc.dart';

class MapState extends Equatable {
  /*Variables para saber si el mapa esta cargado y
  para seguir o no al usuario*/
  final bool isMapInitialized;
  final bool isFollowingUser;

  const MapState({this.isMapInitialized = false, this.isFollowingUser = true});

  MapState copyWith({
    bool? isMapInitialized,
    bool? isFollowingUser,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      );

  /*Esto para saber si un estado es diferente a otro*/
  @override
  List<Object> get props => [isMapInitialized, isFollowingUser];
}
