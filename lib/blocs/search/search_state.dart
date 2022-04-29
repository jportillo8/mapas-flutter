part of 'search_bloc.dart';

class SearchState extends Equatable {
  /*Esta variable es para determinar si cuando debo mostrar el widget de busqueda*/
  final bool displayManualMarker;
  /*Variable para almacenas el listado de busquedas*/
  final List<Feature> places;
  /*Lista de ubicaciones*/
  final List<Feature> history;

  const SearchState({
    this.displayManualMarker = false,
    this.places = const [],
    this.history = const [],
  });

  SearchState copyWith({
    bool? displayManualMarker,
    List<Feature>? places,
    List<Feature>? history,
  }) =>
      SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        places: places ?? this.places,
        history: history ?? this.history,
      );

  @override
  List<Object> get props => [displayManualMarker, places, history];
}
