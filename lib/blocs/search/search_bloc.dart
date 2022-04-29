import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter_x0/models/models.dart';
import 'package:maps_flutter_x0/services/services.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  /*Trayenodo el servicio de peticion a este bloc*/
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(SearchState()) {
    /*Con el evento disparado de los botones configurados vamos emitir 
    un nuevo evento el cual cambia el estado*/
    on<OnActivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: true)));
    on<OnDeactivateManualMarkerEvent>(
        (event, emit) => emit(state.copyWith(displayManualMarker: false)));
    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    on<AddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.place, ...state.history])));
  }

  /*Esta funcion me sirve para poder llamar a mi traffic service*/
  /*Con esto mandamos a llamar la funcion que esta el service, por eso creamos
  instacia y el bloc lo expone en todos lo widgets*/
  Future<RouteDestination> getCoorsStarrToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);
    // Esto se lo debemos mandar al mapBloc quien tiene el control de las polylines

    /*Decodificando el geometry*/
    final geometry = trafficResponse.routes[0].geometry;
    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;
    /*Decodificar----google_polyline_algorithm */
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coors) => LatLng(coors[0].toDouble(), coors[1].toDouble()))
        .toList();

    return RouteDestination(
        points: latLngList, duration: duration, distance: distance);
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final newPlaces = await trafficService.getResultsByQuery(proximity, query);

    add(OnNewPlacesFoundEvent(newPlaces));
  }
}
