import 'package:dio/dio.dart';

const accessToken =
    'pk.eyJ1IjoianBvcnRpbGxvOCIsImEiOiJja3VyNG9sMDQzazZrMzBwaHV1eDJ1M3ExIn0.B0G7xCSqb-W0ovrIeTtYhw';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /*Esta clase como su nombre lo indica intercepta la peticion http
    y vamos a continuacion configuramos los queryParmetres*/
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': 'false',
      'access_token': accessToken
    });

    super.onRequest(options, handler);
  }
}
