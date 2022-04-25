import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
}
