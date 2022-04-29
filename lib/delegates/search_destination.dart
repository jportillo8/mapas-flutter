import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/models/models.dart';

/*En este caso retornaremos nuestro modelo SearchResult, por lo que esta
definido en este Head*/
class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: 'Buscar...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  /*El query*/
  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnowLocation!;
    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
            itemCount: places.length,
            itemBuilder: (context, i) {
              final place = places[i];
              return ListTile(
                title: Text(place.text),
                subtitle: Text(place.placeName),
                leading: const Icon(Icons.place_outlined, color: Colors.black),
                onTap: () {
                  // print('Enviar a este lugar $place');
                  final result = SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(place.center[1], place.center[0]),
                      name: place.text,
                      description: place.placeName);
                  close(context, result);
                  searchBloc.add(AddToHistoryEvent(place));
                },
              );
            },
            separatorBuilder: (context, i) => Divider());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
          leading: const Icon(Icons.location_on_outlined, color: Colors.black),
          title: const Text('Colocar la ubicacion manualmente',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ),
        // Barre los elemtos y devuelve un lista de widgets
        ...history.map((place) => ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(Icons.place_outlined, color: Colors.black),
              onTap: () {
                final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(place.center[1], place.center[0]),
                    name: place.text,
                    description: place.placeName);
                close(context, result);
              },
            ))
      ],
    );
  }
}
