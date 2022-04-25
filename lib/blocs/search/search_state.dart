part of 'search_bloc.dart';

class SearchState extends Equatable {
  /*Esta variable es para determinar si cuando debo mostrar el widget de busqueda*/
  final bool displayManualMarker;

  const SearchState({this.displayManualMarker = false});

  SearchState copyWith({bool? displayManualMarker}) => SearchState(
      displayManualMarker: displayManualMarker ?? this.displayManualMarker);

  @override
  List<Object> get props => [displayManualMarker];
}
