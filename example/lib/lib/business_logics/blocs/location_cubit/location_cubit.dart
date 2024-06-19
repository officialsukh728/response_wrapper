import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationCubit extends Cubit<LocationState> {
  Timer? locationUpdateTimer;

  LocationCubit() : super(const LocationState()){
    startLocationUpdateTimer();
  }

  void startLocationUpdateTimer() {
    locationUpdateTimer?.cancel();
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      getCurrentPositionIfAddressIsNull();
    });
  }

  @override
  Future<void> close() {
    locationUpdateTimer?.cancel();
    return super.close();
  }

  Future<void> getCurrentPositionIfAddressIsNull() async {
    if (state.address == null) {
      await getCurrentPosition();
    }
  }

  Future<void> getCurrentPosition() async {
    emit(state.copyWith(loading:true));
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      emit(state.copyWith(errorMessage:"Location permission denied"));
      return;
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String currentAddress = "N/A";
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        currentAddress = '${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        _saveUserLocation(position, currentAddress);
      }
      emit(state.copyWith(position:position, address: currentAddress));
    } catch (e) {
      emit(state.copyWith(errorMessage:e.toString()));
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      if(await Permission.location.isGranted) return true;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
            _customLocationSnackBar(
                "Location services are disabled. Please enable the services");
            return false;
          }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              _customLocationSnackBar('Location permissions are denied');
              return false;
            }
          }else if (permission == LocationPermission.deniedForever) {
            _customLocationSnackBar(
                'Location permissions are permanently denied, we cannot request permissions.');
            return false;
          }
      return true;
    } catch (e,t) {
      errorLog(e.toString()+t.toString());
      return false;
    }
  }

  Future<void> _saveUserLocation(Position position, String address) async {
    try {
      final currentPosition = Position.fromMap({
        "longitude": position.longitude,
        "latitude": position.latitude,
        "timestamp": 1628475875000,
        "accuracy": 10.0,
        "altitude": 100.0,
        "heading": 90.0,
        "speed": 5.0,
        "speedAccuracy": 2.0,
        "floor": null,
        "isMocked": false,
      });
      emit(state.copyWith(position: currentPosition));
    } catch (e) {
      errorLog(e.toString(), fun: "position parse");
    }
  }

  void _customLocationSnackBar(String title) {
    if (globalBuildContextExits) {
      errorLog(title);
      // locationPermissionDialog(buildContext: globalBuildContext);
    }
  }
}

class LocationState extends Equatable {
  final Position? position;
  final String? address;
  final String? errorMessage;
  final bool loading;

  const LocationState({
    this.position,
    this.address,
    this.errorMessage,
    this.loading = false,
  });

  LocationState copyWith({
    Position? position,
    String? address,
    String? errorMessage,
    bool loading = false,
  }) {
    return LocationState(
      loading: loading,
      address: address??this.address,
      position: position??this.position,
      errorMessage: errorMessage??this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        position,
        address,
        errorMessage,
        loading,
      ];
}
