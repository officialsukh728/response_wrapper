// To parse this JSON data, do
//
//     final earnerAdvertisementModel = earnerAdvertisementModelFromJson(jsonString);

import 'dart:convert';

import 'package:sample/models/add_advertisement_model.dart';
import 'package:sample/models/add_screen_model.dart';
import 'package:sample/models/payment_list_model.dart';

EarnerAdvertisementModel earnerAdvertisementModelFromJson(String str) => EarnerAdvertisementModel.fromJson(json.decode(str));

String earnerAdvertisementModelToJson(EarnerAdvertisementModel data) => json.encode(data.toJson());

class EarnerAdvertisementModel {
  int? statusCode;
  String? message;
  int? page;
  int? totalPages;
  List<EarnerAdvertisementData>? data;

  EarnerAdvertisementModel({
    this.statusCode,
    this.message,
    this.page,
    this.totalPages,
    this.data,
  });

  EarnerAdvertisementModel copyWith({
    int? statusCode,
    String? message,
    int? page,
    int? totalPages,
    List<EarnerAdvertisementData>? data,
  }) =>
      EarnerAdvertisementModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        data: data ?? this.data,
      );

  factory EarnerAdvertisementModel.fromJson(Map<String, dynamic> json) => EarnerAdvertisementModel(
    statusCode: json["statusCode"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    data: json["data"] == null ? [] : List<EarnerAdvertisementData>.from(json["data"]!.map((x) => EarnerAdvertisementData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class EarnerAdvertisementData {
  AdvertisementData? advertisement;
  ScreenData? screen;
  PaymentDetail? paymentDetail;

  EarnerAdvertisementData({
    this.advertisement,
    this.paymentDetail,
    this.screen,
  });

  EarnerAdvertisementData copyWith({
    AdvertisementData? advertisement,
    ScreenData? screen,
  }) =>
      EarnerAdvertisementData(
        advertisement: advertisement ?? this.advertisement,
        screen: screen ?? this.screen,
      );

  factory EarnerAdvertisementData.fromJson(Map<String, dynamic> json) => EarnerAdvertisementData(
    advertisement: json["advertisement"] == null ? null : AdvertisementData.fromJson(json["advertisement"]),
    screen: json["screen"] == null ? null : ScreenData.fromJson(json["screen"]),
    paymentDetail: json["payment_detail"] == null ? null : PaymentDetail.fromJson(json["payment_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "advertisement": advertisement?.toJson(),
    "screen": screen?.toJson(),
    "payment_detail": paymentDetail?.toJson(),
  };
}
