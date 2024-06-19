// To parse this JSON data, do
//
//     final advertisementListModel = advertisementListModelFromJson(jsonString);

import 'dart:convert';

AdvertisementListModel advertisementListModelFromJson(String str) => AdvertisementListModel.fromJson(json.decode(str));

String advertisementListModelToJson(AdvertisementListModel data) => json.encode(data.toJson());

class AdvertisementListModel {
  int? statusCode;
  String? message;
  int? page;
  int? totalPages;
  List<AdvertisementData>? data;

  AdvertisementListModel({
    this.statusCode,
    this.message,
    this.page,
    this.totalPages,
    this.data,
  });

  AdvertisementListModel copyWith({
    int? statusCode,
    String? message,
    int? page,
    int? totalPages,
    List<AdvertisementData>? data,
  }) =>
      AdvertisementListModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        data: data ?? this.data,
      );

  factory AdvertisementListModel.fromJson(Map<String, dynamic> json) => AdvertisementListModel(
    statusCode: json["statusCode"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    data: json["data"] == null ? [] : List<AdvertisementData>.from(json["data"]!.map((x) => AdvertisementData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AdvertisementData {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? campaignLink;
  String? video;
  List<String>? photos;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? uniqueId;
  String? rejectionReason;
  int? v;
  DateTime? date;
  double? latitude;
  String? location;
  double? longitude;
  String? time;
  String? end_time;
  String? start_time;

  AdvertisementData({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.campaignLink,
    this.video,
    this.rejectionReason,
    this.photos,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.uniqueId,
    this.v,
    this.date,
    this.latitude,
    this.location,
    this.longitude,
    this.time,
    this.end_time,
    this.start_time,
  });

  AdvertisementData copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? campaignLink,
    String? rejectionReason,
    String? video,
    List<String>? photos,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? uniqueId,
    int? v,
    DateTime? date,
    double? latitude,
    String? location,
    double? longitude,
    String? time,
  }) =>
      AdvertisementData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        rejectionReason: rejectionReason ?? this.rejectionReason,
        description: description ?? this.description,
        campaignLink: campaignLink ?? this.campaignLink,
        video: video ?? this.video,
        photos: photos ?? this.photos,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        uniqueId: uniqueId ?? this.uniqueId,
        v: v ?? this.v,
        date: date ?? this.date,
        latitude: latitude ?? this.latitude,
        location: location ?? this.location,
        longitude: longitude ?? this.longitude,
        time: time ?? this.time,
      );

  factory AdvertisementData.fromJson(Map<String, dynamic> json) => AdvertisementData(
    id: json["_id"],
    userId: json["userId"],
    name: json["name"],
    rejectionReason: json["rejection_reason"],
    description: json["description"],
    campaignLink: json["campaign_link"],
    video: json["video"],
    photos: json["photos"] == null ? [] : List<String>.from(json["photos"]!.map((x) => x)),
    status: json["status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    uniqueId: json["uniqueId"],
    v: json["__v"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    latitude: json["latitude"]?.toDouble(),
    location: json["location"],
    longitude: json["longitude"]?.toDouble(),
    time: json["time"],
    end_time: json["end_time"],
    start_time: json["start_time"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "name": name,
    "rejection_reason": rejectionReason,
    "description": description,
    "campaign_link": campaignLink,
    "video": video,
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x)),
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "uniqueId": uniqueId,
    "__v": v,
    "date": date?.toIso8601String(),
    "latitude": latitude,
    "location": location,
    "longitude": longitude,
    "time": time,
    "end_time": end_time,
    "start_time": start_time,
  };
}

class   AdvertisementModel {
  int? statusCode;
  int? page;
  String? message;
  AdvertisementData? data;

  AdvertisementModel({
    this.statusCode,
    this.page,
    this.message,
    this.data,
  });

  AdvertisementModel copyWith({
    int? statusCode,
    int? page,
    String? message,
    AdvertisementData? data,
  }) =>
      AdvertisementModel(
        statusCode: statusCode ?? this.statusCode,
        page: page ?? this.page,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) => AdvertisementModel(
    statusCode: json["statusCode"],
    page: json["page"],
    message: json["message"],
    data: json["data"] == null ? null : AdvertisementData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "page": page,
    "message": message,
    "data": data?.toJson(),
  };
}


