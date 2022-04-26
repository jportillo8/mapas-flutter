import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter_x0/services/services.dart';

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
  }

  /*Esta funcion me sirve para poder llamar a mi traffic service*/
  /*Con esto mandamos a llamar la funcion que esta el service, por eso creamos
  instacia y el bloc lo expone en todos lo widgets*/
  Future getCoorsStarrToEnd(LatLng start, LatLng end) async {
    final resp = await trafficService.getCoorsStartToEnd(start, end);
  }
}
