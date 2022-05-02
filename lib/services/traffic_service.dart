import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter_x0/models/models.dart';
import 'package:maps_flutter_x0/services/services.dart';

class TrafficService {
/*Basado en la geolocalizacion que informacion hay en esas 
coordenadas e informacion de trafico*/
  final Dio _dioTraffic;
  final Dio _dioPlaces;
  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlaceUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';
  // Añadido interceptor.
  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseTrafficUrl/driving/$coorsString';

    final resp = await _dioTraffic.get(url);
    /*Desppues de crear el modelo podemos mapear la respuesta
    este es application json nota: si es text entonces seria fromJson()... */
    final data = TrafficResponse.fromMap(resp.data);
    return data;
  }

  /*Funcion para el query es decir la palabra de objetivo de busqueda
  en el search*/
  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];
    final url = '$_basePlaceUrl/$query.json';
    final resp = await _dioPlaces.get(url, queryParameters: {
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'limit': 7
    });

    final placesRespose = PlacesResponse.fromMap(resp.data);
    print(resp);
    return placesRespose.features; //Lugares => Features
  }

  /*Geocoding Reverse*/
  Future<Feature> getInfomationByCoors(LatLng coors) async {
    final url = '$_basePlaceUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url, queryParameters: {'limit': 1});

    final placesResponse = PlacesResponse.fromMap(resp.data);
    return placesResponse.features[0];
  }
}
