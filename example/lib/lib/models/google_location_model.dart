// To parse this JSON data, do
//
//     final predictionsListModel = predictionsListModelFromJson(jsonString);

import 'dart:convert';

PlaceModel placeModelFromJson(String str) =>
    PlaceModel.fromJson(json.decode(str));

String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class PlaceModel {
  String? status;
  ResultData? result;

  PlaceModel({
    this.status,
    this.result,
  });

  PlaceModel copyWith({
    String? status,
    ResultData? result,
  }) =>
      PlaceModel(
        status: status ?? this.status,
        result: result ?? this.result,
      );

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        status: json["status"],
        result: json["result"] == null ? null : ResultData.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result?.toJson(),
      };
}

class ResultData {
  GeometryData? geometry;
  String? name;
  String? placeId;

  ResultData({
    this.geometry,
    this.name,
    this.placeId,
  });

  ResultData copyWith({
    GeometryData? geometry,
    String? name,
    String? placeId,
  }) =>
      ResultData(
        geometry: geometry ?? this.geometry,
        name: name ?? this.name,
        placeId: placeId ?? this.placeId,
      );

  factory ResultData.fromJson(Map<String, dynamic> json) => ResultData(
        geometry: json["geometry"] == null
            ? null
            : GeometryData.fromJson(json["geometry"]),
        name: json["name"],
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry?.toJson(),
        "name": name,
        "place_id": placeId,
      };
}

GeometryData geometryDataFromJson(String str) => GeometryData.fromJson(json.decode(str));

String geometryDataToJson(GeometryData data) => json.encode(data.toJson());

class GeometryData {
  GeometryLocation? location;
  GeometryViewport? viewport;

  GeometryData({
    this.location,
    this.viewport,
  });

  GeometryData copyWith({
    GeometryLocation? location,
    GeometryViewport? viewport,
  }) =>
      GeometryData(
        location: location ?? this.location,
        viewport: viewport ?? this.viewport,
      );

  factory GeometryData.fromJson(Map<String, dynamic> json) => GeometryData(
    location: json["location"] == null ? null : GeometryLocation.fromJson(json["location"]),
    viewport: json["viewport"] == null ? null : GeometryViewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "viewport": viewport?.toJson(),
  };
}

class GeometryLocation {
  double? lat;
  double? lng;

  GeometryLocation({
    this.lat,
    this.lng,
  });

  GeometryLocation copyWith({
    double? lat,
    double? lng,
  }) =>
      GeometryLocation(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory GeometryLocation.fromJson(Map<String, dynamic> json) => GeometryLocation(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class GeometryViewport {
  GeometryLocation? northeast;
  GeometryLocation? southwest;

  GeometryViewport({
    this.northeast,
    this.southwest,
  });

  GeometryViewport copyWith({
    GeometryLocation? northeast,
    GeometryLocation? southwest,
  }) =>
      GeometryViewport(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  factory GeometryViewport.fromJson(Map<String, dynamic> json) => GeometryViewport(
    northeast: json["northeast"] == null ? null : GeometryLocation.fromJson(json["northeast"]),
    southwest: json["southwest"] == null ? null : GeometryLocation.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast?.toJson(),
    "southwest": southwest?.toJson(),
  };
}

PredictionsListModel predictionsListModelFromJson(String str) =>
    PredictionsListModel.fromJson(json.decode(str));

String predictionsListModelToJson(PredictionsListModel data) =>
    json.encode(data.toJson());

class PredictionsListModel {
  List<PredictionData>? predictions;
  String? status;

  PredictionsListModel({
    this.predictions,
    this.status,
  });

  PredictionsListModel copyWith({
    List<PredictionData>? predictions,
    String? status,
  }) =>
      PredictionsListModel(
        predictions: predictions ?? this.predictions,
        status: status ?? this.status,
      );

  factory PredictionsListModel.fromJson(Map<String, dynamic> json) =>
      PredictionsListModel(
        predictions: json["predictions"] == null
            ? []
            : List<PredictionData>.from(
                json["predictions"]!.map((x) => PredictionData.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "predictions": predictions == null
            ? []
            : List<dynamic>.from(predictions!.map((x) => x.toJson())),
        "status": status,
      };
}

class PredictionData {
  String? description;
  String? placeId;
  String? reference;

  PredictionData({
    this.description,
    this.placeId,
    this.reference,
  });

  PredictionData copyWith({
    String? description,
    String? placeId,
    String? reference,
  }) =>
      PredictionData(
        description: description ?? this.description,
        placeId: placeId ?? this.placeId,
        reference: reference ?? this.reference,
      );

  factory PredictionData.fromJson(Map<String, dynamic> json) => PredictionData(
        description: json["description"],
        placeId: json["place_id"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "place_id": placeId,
        "reference": reference,
      };
}
