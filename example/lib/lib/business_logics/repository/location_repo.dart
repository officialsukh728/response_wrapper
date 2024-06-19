import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sample/business_logics/service/dio_services.dart';
import 'package:sample/models/google_location_model.dart';
import 'package:sample/utils/common/print_log.dart';

class LatLngModel {
  final double latitude;
  final double longitude;

  LatLngModel(this.latitude, this.longitude);
}

abstract class LocationRepo {
  Future<LatLngModel> getCurrentLatLng();

  Placemark getPlacemarkFromGoogleRes(components);

  Future<List?> getAddressWithLatLang(LatLngModel latLng);

  Future<PlaceModel> getPlace(String placeId);

  Future<PredictionsListModel> locationAutoComplete(String input);
  Future<String?> getPlaceId({
    required double latitude,
    required double longitude,
    required ValueChanged<String?> valueChanged,
    required ValueChanged<Placemark?> valuePlacemark,
  });
}

class LocationRepoImp extends LocationRepo {
  final String key = "AIzaSyAvpMAnMMRYUgNJjeqfZRTJVt1BfQ-HyEw";

  @override
  Future<List?> getAddressWithLatLang(LatLngModel latLng) async {
    const String apikey = "AIzaSyAvpMAnMMRYUgNJjeqfZRTJVt1BfQ-HyEw";
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apikey";

    Response res = await Dio().get(apiurl);
    if (res.statusCode == 200) {
      Map data = res.data;

      if (data["status"] == "OK") {
        if (data["results"].length > 0) {
          Map firstresult = data["results"][0]; //select the first address

          Placemark place =
              getPlacemarkFromGoogleRes(firstresult["address_components"]);

          String commaString(s) {
            if (s != null) {
              return "$s, ";
            } else {
              return "";
            }
          }

          String addressB =
              '${commaString(place.street)}${commaString(place.subLocality)}${commaString(place.locality)}${commaString(place.postalCode)}${commaString(place.country)}';

          printLog("addressB $addressB");
          printLog("addressB $place");

          return [addressB, place];
        }
      } else {
        printLog(data["error_message"]);
      }
    } else {
      printLog("error while fetching geocoding data");
    }
    return null;
  }

  @override
  Future<LatLngModel> getCurrentLatLng() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLngModel(position.latitude, position.longitude);
  }

  @override
  Placemark getPlacemarkFromGoogleRes(components) {
    Placemark? placemark;
    Map place = {};

    for (var item in components) {
      for (var type in item["types"]) {
        // conditions
        if (type == "name") {
          place["name"] = item["long_name"];
        }

        if (type == "street") {
          place["street"] = item["long_name"];
        }
        if (type == "sublocality") {
          place["sublocality"] = item["long_name"];
        }

        if (type == "locality") {
          place["locality"] = item["long_name"];
        }

        if (type == "administrative_area_level_2") {
          place["subAdministrativeArea"] = item["long_name"];
        }

        if (type == "administrative_area_level_1") {
          place["administrativeArea"] = item["long_name"];
        }

        if (type == "postal_code") {
          place["postalCode"] = item["long_name"];
        }

        if (type == "country") {
          place["country"] = item["long_name"];
        }
      }
    }

    placemark = Placemark(
      name: place["name"],
      street: place["street"],
      locality: place["locality"],
      subLocality: place["sublocality"],
      administrativeArea: place["administrativeArea"],
      subAdministrativeArea: place["subAdministrativeArea"],
      postalCode: place["postalCode"],
      country: place["country"],
    );

    return placemark;
  }

  Placemark getPlacemarkAddressComponent(Map<String, dynamic> json) {
    List<AddressComponent> addressComponents = (json['address_components'] as List)
        .map((componentJson) => AddressComponent.fromJson(componentJson))
        .toList();
    String? name;
    String? street;
    String? locality;
    String? subLocality;
    String? administrativeArea;
    String? subAdministrativeArea;
    String? postalCode;
    String? country;

    for (var component in addressComponents) {
      if (component.types?.contains('point_of_interest')==true) {
        name = component.longName;
      } else if (component.types?.contains('street_address')==true) {
        street = component.longName;
      } else if (component.types?.contains('locality')==true) {
        locality = component.longName;
      } else if (component.types?.contains('sublocality')==true) {
        subLocality = component.longName;
      } else if (component.types?.contains('administrative_area_level_1')==true) {
        administrativeArea = component.longName;
      } else if (component.types?.contains('administrative_area_level_2')==true) {
        subAdministrativeArea = component.longName;
      } else if (component.types?.contains('postal_code')==true) {
        postalCode = component.longName;
      } else if (component.types?.contains('country')==true) {
        country = component.longName;
      }
    }

    return Placemark(
      name: name??"",
      street: street??"",
      locality: locality??"",
      subLocality: subLocality??"",
      administrativeArea: administrativeArea??"",
      subAdministrativeArea: subAdministrativeArea??"",
      postalCode: postalCode??"",
      country: country??"",
    );
  }

  @override
  Future<PredictionsListModel> locationAutoComplete(String input) async {
    try {
      final String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$key";
      Response res = await Dio().get(url);
      return PredictionsListModel.fromJson(res.data);
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
    } catch (e, t) {
      errorLog(e.toString() + t.toString(), fun: "locationAutoComplete");
    }
    return PredictionsListModel();
  }

  @override
  Future<String?> getPlaceId({
    required double latitude,
    required double longitude,
    required ValueChanged<String?> valueChanged,
    required ValueChanged<Placemark?> valuePlacemark,
  }) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key';

    final dio = Dio();
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if(jsonResponse['results']==null||(jsonResponse['results'] as List).isEmpty)return null;
        final placeId = jsonResponse['results'][0]['place_id'];
        Placemark place =
        getPlacemarkAddressComponent(jsonResponse['results'][0]);
        valueChanged(jsonResponse['results'][0]['formatted_address']);
        valuePlacemark(place);
        return placeId;
      }
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
    } catch (e, t) {
      errorLog(e.toString() + t.toString(), fun: "getPlace");
    }
    return null;
  }

  @override
  Future<PlaceModel> getPlace(String placeId) async {
    try {
      final String url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";
      Response res = await Dio().get(url);
      return PlaceModel.fromJson(res.data);
    } on DioException catch (e) {
      responseErrorHandler(response: e.response, dioErrorType: e.type);
    } catch (e, t) {
      errorLog(e.toString() + t.toString(), fun: "getPlace");
    }
    return PlaceModel();
  }
}
class AddressComponent {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'],
      shortName: json['short_name'],
      types: List<String>.from(json['types']),
    );
  }
}
