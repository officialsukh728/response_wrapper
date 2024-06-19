// To parse this JSON data, do
//
//     final heatmapModel = heatmapModelFromJson(jsonString);

import 'dart:convert';

HeatMapModel heatmapModelFromJson(String str) => HeatMapModel.fromJson(json.decode(str));

String heatmapModelToJson(HeatMapModel data) => json.encode(data.toJson());

class HeatMapModel {
  int? statusCode;
  String? message;
  List<HeatmapModelData>? data;

  HeatMapModel({
    this.statusCode,
    this.message,
    this.data,
  });

  HeatMapModel copyWith({
    int? statusCode,
    String? message,
    List<HeatmapModelData>? data,
  }) =>
      HeatMapModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory HeatMapModel.fromJson(Map<String, dynamic> json) => HeatMapModel(
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<HeatmapModelData>.from(json["data"]!.map((x) => HeatmapModelData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HeatmapModelData {
  String? location;
  int? intensity;
  num? latitude;
  num? longitude;

  HeatmapModelData({
    this.location,
    this.intensity,
    this.latitude,
    this.longitude,
  });

  HeatmapModelData copyWith({
    String? location,
    int? popularityPercentage,
    num? latitude,
    num? longitude,
  }) =>
      HeatmapModelData(
        location: location ?? this.location,
        intensity: popularityPercentage ?? this.intensity,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory HeatmapModelData.fromJson(Map<String, dynamic> json) => HeatmapModelData(
    location: json["location"],
    intensity: json["popularity_percentage"],
    latitude: num.tryParse(json["latitude"]??"0"),
    longitude: num.tryParse(json["longitude"]??"0"),
  );

  Map<String, dynamic> toJson() => {
    "location": location,
    "popularity_percentage": intensity,
    "latitude": latitude,
    "longitude": longitude,
  };
}
