// To parse this JSON data, do
//
//     final dashboardCountModel = dashboardCountModelFromJson(jsonString);

import 'dart:convert';
// To parse this JSON data, do
//
//     final advertiserDashboardCountModel = advertiserDashboardCountModelFromJson(jsonString);

import 'dart:convert';

AdvertiserDashboardCountModel advertiserDashboardCountModelFromJson(String str) => AdvertiserDashboardCountModel.fromJson(json.decode(str));

String advertiserDashboardCountModelToJson(AdvertiserDashboardCountModel data) => json.encode(data.toJson());

class AdvertiserDashboardCountModel {
  num? statusCode;
  String? message;
  String? totalScans;
  num? totalAdverisement;
  num? totalAdvertisementApprove;
  num? totalAdvertisementPending;
  num? totalAdvertisementRejected;
  String? totalHours;
  double? amount;

  AdvertiserDashboardCountModel({
    this.statusCode,
    this.message,
    this.totalScans,
    this.totalAdverisement,
    this.totalAdvertisementApprove,
    this.totalAdvertisementPending,
    this.totalAdvertisementRejected,
    this.totalHours,
    this.amount,
  });

  AdvertiserDashboardCountModel copyWith({
    num? statusCode,
    String? message,
    String? totalScans,
    num? totalAdverisement,
    num? totalAdvertisementApprove,
    num? totalAdvertisementPending,
    num? totalAdvertisementRejected,
    String? totalHours,
    double? amount,
  }) =>
      AdvertiserDashboardCountModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        totalScans: totalScans ?? this.totalScans,
        totalAdverisement: totalAdverisement ?? this.totalAdverisement,
        totalAdvertisementApprove: totalAdvertisementApprove ?? this.totalAdvertisementApprove,
        totalAdvertisementPending: totalAdvertisementPending ?? this.totalAdvertisementPending,
        totalAdvertisementRejected: totalAdvertisementRejected ?? this.totalAdvertisementRejected,
        totalHours: totalHours ?? this.totalHours,
        amount: amount ?? this.amount,
      );

  factory AdvertiserDashboardCountModel.fromJson(Map<String, dynamic> json) => AdvertiserDashboardCountModel(
    statusCode: json["statusCode"],
    message: json["message"],
    totalScans: json["total_scans"],
    totalAdverisement: json["total_adverisement"],
    totalAdvertisementApprove: json["total_advertisement_approve"],
    totalAdvertisementPending: json["total_advertisement_pending"],
    totalAdvertisementRejected: json["total_advertisement_rejected"],
    totalHours: json["total_hours"],
    amount: json["amount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "total_scans": totalScans,
    "total_adverisement": totalAdverisement,
    "total_advertisement_approve": totalAdvertisementApprove,
    "total_advertisement_pending": totalAdvertisementPending,
    "total_advertisement_rejected": totalAdvertisementRejected,
    "total_hours": totalHours,
    "amount": amount,
  };
}

EarnerDashboardCountModel dashboardCountModelFromJson(String str) => EarnerDashboardCountModel.fromJson(json.decode(str));

String dashboardCountModelToJson(EarnerDashboardCountModel data) => json.encode(data.toJson());

class EarnerDashboardCountModel {
  num? statusCode;
  String? message;
  num? advertisementPlay;
  num? totalScreen;
  num? totalScreenApprove;
  num? totalScreenPending;
  num? totalScreenRejected;
  String? totalHours;
  String? amount;

  EarnerDashboardCountModel({
    this.statusCode,
    this.message,
    this.advertisementPlay,
    this.totalScreen,
    this.totalScreenApprove,
    this.totalScreenPending,
    this.totalScreenRejected,
    this.totalHours,
    this.amount,
  });

  EarnerDashboardCountModel copyWith({
    num? statusCode,
    String? message,
    num? advertisementPlay,
    num? totalScreen,
    num? totalScreenApprove,
    num? totalScreenPending,
    num? totalScreenRejected,
    String? totalHours,
    String? amount,
  }) =>
      EarnerDashboardCountModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        advertisementPlay: advertisementPlay ?? this.advertisementPlay,
        totalScreen: totalScreen ?? this.totalScreen,
        totalScreenApprove: totalScreenApprove ?? this.totalScreenApprove,
        totalScreenPending: totalScreenPending ?? this.totalScreenPending,
        totalScreenRejected: totalScreenRejected ?? this.totalScreenRejected,
        totalHours: totalHours ?? this.totalHours,
        amount: amount ?? this.amount,
      );

  factory EarnerDashboardCountModel.fromJson(Map<String, dynamic> json) => EarnerDashboardCountModel(
    statusCode: json["statusCode"],
    message: json["message"],
    advertisementPlay: json["advertisementPlay"],
    totalScreen: json["total_screen"],
    totalScreenApprove: json["total_screen_approve"],
    totalScreenPending: json["total_screen_pending"],
    totalScreenRejected: json["total_screen_rejected"],
    totalHours: json["total_hours"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "advertisementPlay": advertisementPlay,
    "total_screen": totalScreen,
    "total_screen_approve": totalScreenApprove,
    "total_screen_pending": totalScreenPending,
    "total_screen_rejected": totalScreenRejected,
    "total_hours": totalHours,
    "amount": amount,
  };
}
