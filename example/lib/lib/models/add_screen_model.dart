// To parse this JSON data, do
//
//     final screenListModel = screenListModelFromJson(jsonString);

import 'dart:convert';

ScreenListModel screenListModelFromJson(String str) => ScreenListModel.fromJson(json.decode(str));

String screenListModelToJson(ScreenListModel data) => json.encode(data.toJson());

class ScreenListModel {
  int? statusCode;
  String? message;
  int? page;
  int? totalPages;
  List<ScreenData>? data;

  ScreenListModel({
    this.statusCode,
    this.message,
    this.page,
    this.totalPages,
    this.data,
  });

  ScreenListModel copyWith({
    int? statusCode,
    String? message,
    int? page,
    int? totalPages,
    List<ScreenData>? data,
  }) =>
      ScreenListModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        data: data ?? this.data,
      );

  factory ScreenListModel.fromJson(Map<String, dynamic> json) => ScreenListModel(
    statusCode: json["statusCode"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    data: json["data"] == null ? [] : List<ScreenData>.from(json["data"]!.map((x) => ScreenData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ScreenData {
  String? id;
  String? userId;
  String? name;
  String? description;
  dynamic? dimensionHeight;
  dynamic? dimensionWidth;
  String? location;
  double? latitude;
  double? longitude;
  String? photo;
  String? rejectionReason;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? uniqueId;
  int? v;
  num? screenPrice;
  num? total_price;
  num? screen_price;
  num? platform_charges;

  ScreenData({
    this.id,
    this.screenPrice,
    this.userId,
    this.name,
    this.description,
    this.dimensionHeight,
    this.dimensionWidth,
    this.rejectionReason,
    this.location,
    this.latitude,
    this.longitude,
    this.photo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.uniqueId,
    this.total_price,
    this.screen_price,
    this.platform_charges,
    this.v,
  });

  factory ScreenData.fromJson(Map<String, dynamic> json) => ScreenData(
    id: json["_id"],
    userId: json["userId"],
    name: json["name"],
    screenPrice: json["price"],
    description: json["description"],
    dimensionHeight: json["dimension_height"],
    dimensionWidth: json["dimension_width"],
    location: json["location"],
    rejectionReason: json["rejection_reason"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    photo: json["photo"],
    status: json["status"],
    total_price: json["total_price"],
    screen_price: json["screen_price"],
    platform_charges: json["platform_charges"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    uniqueId: json["uniqueId"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "name": name,
    "price": screenPrice,
    "rejection_reason": rejectionReason,
    "description": description,
    "dimension_height": dimensionHeight,
    "dimension_width": dimensionWidth,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "photo": photo,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "uniqueId": uniqueId,
    "total_price": total_price,
    "screen_price": screen_price,
    "platform_charges": platform_charges,
    "__v": v,
  };
}

class AddScreenModel {
  int? statusCode;
  int? page;
  String? message;
  ScreenData? data;

  AddScreenModel({
    this.statusCode,
    this.page,
    this.message,
    this.data,
  });

  AddScreenModel copyWith({
    int? statusCode,
    int? page,
    String? message,
    ScreenData? data,
  }) =>
      AddScreenModel(
        statusCode: statusCode ?? this.statusCode,
        page: page ?? this.page,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AddScreenModel.fromJson(Map<String, dynamic> json) => AddScreenModel(
    statusCode: json["statusCode"],
    page: json["page"],
    message: json["message"],
    data: json["data"] == null ? null : ScreenData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

