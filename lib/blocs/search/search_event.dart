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
