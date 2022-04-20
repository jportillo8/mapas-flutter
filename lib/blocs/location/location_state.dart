part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  /*Ultima ubicacion que conozco de el usuario*/
  final LatLng? lastKnowLocation;
  final List<LatLng> myLocationHistory;
  // TODO
  // ultimo geolocation
  // historia

  const LocationState(
      {this.followingUser = false, this.lastKnowLocation, myLocationHistory})
      : myLocationHistory = myLocationHistory ?? const [];

  LocationState copyWith({
    bool? followingUser,
    LatLng? lastKnowLocation,
    List<LatLng>? myLocationHistory,
  }) =>
      LocationState(
        followingUser: followingUser ?? this.followingUser,
        lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
        myLocationHistory: myLocationHistory ?? this.myLocationHistory,
      );

  @override
  List<Object?> get props =>
      [followingUser, lastKnowLocation, myLocationHistory];
}
