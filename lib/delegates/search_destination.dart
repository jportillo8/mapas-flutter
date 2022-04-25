import 'package:flutter/material.dart';
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

  @override
  Widget buildResults(BuildContext context) {
    return const Text('build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
        )
      ],
    );
  }
}
