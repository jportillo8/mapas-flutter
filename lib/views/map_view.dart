import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_flutter_x0/blocs/blocks.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation;
  /*Agregando Polylines*/
  final Set<Polyline> polylines;

  const MapView(
      {Key? key, required this.initialLocation, required this.polylines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    //
    final CameraPosition initialCameraPosition =
        CameraPosition(target: initialLocation, zoom: 15);

    /*Vamos definir las dimensiones del mapa dependiendo
    de las dimension de el telefono*/
    final size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        height: size.height,
        child: Listener(
          onPointerMove: (pointerMoveEvent) =>
              mapBloc.add(OnStopMapFollowingUser()),
          child: GoogleMap(
            // mapType: MapType.terrain,
            // mapToolbarEnabled: true,
            // liteModeEnabled: true,
            initialCameraPosition: initialCameraPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            /*Agregando Polylines*/
            polylines: polylines,

            //
            onMapCreated: (controller) =>
                mapBloc.add(OnMapInitializedEvent(controller)),

            // TODO Markers
            // TODO polylines
            // TODO Cuando se mueve el mapa
          ),
        ));
  }
}
