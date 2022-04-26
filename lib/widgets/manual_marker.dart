import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        /*Averiguamos si el estado esta en true o false*/
        return state.displayManualMarker
            ? const _ManualMarkerBody()
            : const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    /*Con el fin de confirmar el destino a traves de las coordenadas*/
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    /*Con el  fin de saber la ultima ubicacion traemos el bloc Location*/
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    /*Con el  fin de saber la  ubicacion de la camara traemos el map Location*/
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned(top: 70, left: 20, child: _BtnBack()),
            Center(
                child: Transform.translate(
              offset: Offset(0, -22),
              child: BounceInDown(
                  from: 100, child: Icon(Icons.location_on_rounded, size: 60)),
            )),
            Positioned(
                bottom: 70,
                left: 40,
                child: FadeInUp(
                  duration: Duration(milliseconds: 300),
                  child: MaterialButton(
                      height: 50,
                      elevation: 0,
                      color: Colors.black,
                      minWidth: size.width - 120,
                      shape: StadiumBorder(),
                      child: Text('Confirmar destino',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          )),
                      onPressed: () async {
                        // TODO : Loading
                        final start = locationBloc.state.lastKnowLocation;
                        if (start == null) return;
                        final end = mapBloc.mapCenter;
                        if (end == null) return;

                        showLoadingMessage(context);

                        /*Esto nos regresa route destination
                        aqui tenemos toda la info para que dibije la polyline*/
                        final destination =
                            await searchBloc.getCoorsStarrToEnd(start, end);
                        await mapBloc.drawRoutePolyline(destination);

                        /*Con el fin de quitar el boton entonces*/
                        searchBloc.add(OnDeactivateManualMarkerEvent());
                        Navigator.pop(context);
                      }),
                )),
          ],
        ));
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: Duration(milliseconds: 300),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            final searchBloc = BlocProvider.of<SearchBloc>(context);
            searchBloc.add(OnDeactivateManualMarkerEvent());
          },
        ),
      ),
    );
  }
}
