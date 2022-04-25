import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter_x0/blocs/blocks.dart';
import 'package:maps_flutter_x0/delegates/delegates.dart';
import 'package:maps_flutter_x0/models/models.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
            ? const SizedBox()
            : FadeInDown(
                duration: Duration(milliseconds: 300), child: _SearchBarBody());
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super(key: key);

  /*Este metodo es para controlar el estado de el bloc search*/
  void onSearchResults(BuildContext context, SearchResult result) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    if (result.manual == true) {
      /*Disparo de el Evento manual*/
      searchBloc.add(OnActivateManualMarkerEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        height: 50,
        child: GestureDetector(
          onTap: () async {
            /*En este punto de la app vamos a crear un buscador*/
            final result = await showSearch(
                context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;
            /*En este punto sabemos las condiciones requeridas por
            el usuario, si es cancel o es manual*/
            onSearchResults(context, result);
            print(result);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: const Text('¿Donde quieres ir?',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ),
      ),
    );
  }
}
