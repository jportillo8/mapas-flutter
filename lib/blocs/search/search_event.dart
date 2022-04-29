part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

// Este evento activa el marcador y boton
class OnActivateManualMarkerEvent extends SearchEvent {}

// Este evento desactiva el marcador y boton
class OnDeactivateManualMarkerEvent extends SearchEvent {}

// Este evento dispara los lugares cercanos
class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;

  const OnNewPlacesFoundEvent(this.places);
}

// Este evento dispara la lista de historial
class AddToHistoryEvent extends SearchEvent {
  final Feature place;

  const AddToHistoryEvent(this.place);
}
