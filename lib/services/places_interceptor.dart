import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoianBvcnRpbGxvOCIsImEiOiJja3VyNG9sMDQzazZrMzBwaHV1eDJ1M3ExIn0.B0G7xCSqb-W0ovrIeTtYhw';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /*Esta clase como su nombre lo indica intercepta la peticion http
    y vamos a continuacion configuramos los queryParmetres*/
    options.queryParameters.addAll({
      'country': 'co',
      // 'limit': 7,
      'language': 'es',
      'access_token': accessToken
    });

    super.onRequest(options, handler);
  }
}
