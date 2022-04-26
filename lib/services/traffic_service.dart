import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter_x0/models/models.dart';
import 'package:maps_flutter_x0/services/services.dart';

class TrafficService {
/*Basado en la geolocalizacion que informacion hay en esas 
coordenadas e informacion de trafico*/
  final Dio _dioTraffic;
  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  // Añadido interceptor.
  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor());

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
}
