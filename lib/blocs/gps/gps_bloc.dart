import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  /* La siguiente linea es para poder limpiar el stream 
  aunque no sea necesario para nuestra app ya que este stream
  nunca debe cerrarse*/
  StreamSubscription? gpsServiceSubcription;

  GpsBloc()
      : super(
            const GpsState(isGpsEnable: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnable: event.isGpsEnable,
        isGpsPermissionGranted: event.isGpsPermissionGranted)));

    _init();
  }

  /* Con este metodo vamos a estar escuchando el estado del gps */
  /* Con este metodo vamos a estar escuchando el estado de los privilegios? */
  Future<void> _init() async {
    // final isEnable = await _checkGpsStatus();
    // final isGranted = await _isPermissionGranted();
    // print('isEnable: $isEnable , isGranted: $isGranted');

    final gpsInitStatus =
        await Future.wait([_checkGpsStatus(), _isPermissionGranted()]);

    /* Para que podamos cambiarnos de estado emitimos un evento 
    por que esta funcion esta suscrita al cambio de el evento*/
    add(GpsAndPermissionEvent(
        // isGpsEnable: isEnable, isGpsPermissionGranted: isGranted));
        isGpsEnable: gpsInitStatus[0],
        isGpsPermissionGranted: gpsInitStatus[1]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    print('Primer: $isEnable');
    /*
    Se activa cada vez que los servicios de ubicación están 
    deshabilitados/habilitados en la barra de notificaciones o 
    en la configuración del dispositivo.
     Devuelve ServiceStatus.enabled cuando los servicios de ubicación 
     están habilitados y devuelve ServiceStatus
    .disabled cuando los servicios de ubicación están deshabilitados
    */
    gpsServiceSubcription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
      print('service status: $isEnable');
      add(GpsAndPermissionEvent(
          isGpsEnable: isEnable,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
    });
    return isEnable;
  }

  Future<void> askGpsAcces() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: true));
        // Este metodo abre las configuraciones del telefono
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    /* Si tienes un valor cancelalo si no hagas nada*/
    gpsServiceSubcription?.cancel();
    return super.close();
  }
}
