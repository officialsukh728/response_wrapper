// To parse this JSON data, do
//
//     final paymentListModel = paymentListModelFromJson(jsonString);

import 'dart:convert';

import 'package:sample/models/add_advertisement_model.dart';
import 'package:sample/models/add_screen_model.dart';
import 'package:sample/models/profile_model.dart';

PaymentListModel paymentListModelFromJson(String str) => PaymentListModel.fromJson(json.decode(str));

String paymentListModelToJson(PaymentListModel data) => json.encode(data.toJson());

class PaymentDetail {
  String? id;
  String? advertisementId;
  String? screenId;
  String? userId;
  String? paymentId;
  int? amount;
  int? amountReceived;
  String? type;
  double? platformCharges;
  int? screenPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PaymentDetail({
    this.id,
    this.advertisementId,
    this.screenId,
    this.userId,
    this.paymentId,
    this.amount,
    this.amountReceived,
    this.type,
    this.platformCharges,
    this.screenPrice,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PaymentDetail copyWith({
    String? id,
    String? advertisementId,
    String? screenId,
    String? userId,
    String? paymentId,
    int? amount,
    int? amountReceived,
    String? type,
    double? platformCharges,
    int? screenPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      PaymentDetail(
        id: id ?? this.id,
        advertisementId: advertisementId ?? this.advertisementId,
        screenId: screenId ?? this.screenId,
        userId: userId ?? this.userId,
        paymentId: paymentId ?? this.paymentId,
        amount: amount ?? this.amount,
        amountReceived: amountReceived ?? this.amountReceived,
        type: type ?? this.type,
        platformCharges: platformCharges ?? this.platformCharges,
        screenPrice: screenPrice ?? this.screenPrice,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
    id: json["_id"],
    advertisementId: json["advertisement_id"],
    screenId: json["screen_id"],
    userId: json["user_id"],
    paymentId: json["payment_id"],
    amount: json["amount"],
    amountReceived: json["amount_received"],
    type: json["type"],
    platformCharges: json["platform_charges"]?.toDouble(),
    screenPrice: json["screen_price"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "advertisement_id": advertisementId,
    "screen_id": screenId,
    "user_id": userId,
    "payment_id": paymentId,
    "amount": amount,
    "amount_received": amountReceived,
    "type": type,
    "platform_charges": platformCharges,
    "screen_price": screenPrice,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class PaymentListModel {
  int? statusCode;
  String? message;
  int? page;
  int? totalPages;
  List<PaymentData>? data;

  PaymentListModel({
    this.statusCode,
    this.message,
    this.page,
    this.totalPages,
    this.data,
  });

  PaymentListModel copyWith({
    int? statusCode,
    String? message,
    int? page,
    int? totalPages,
    List<PaymentData>? data,
  }) =>
      PaymentListModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        page: page ?? this.page,
        totalPages: totalPages ?? this.totalPages,
        data: data ?? this.data,
      );

  factory PaymentListModel.fromJson(Map<String, dynamic> json) => PaymentListModel(
    statusCode: json["statusCode"],
    message: json["message"],
    page: json["page"],
    totalPages: json["totalPages"],
    data: json["data"] == null ? [] : List<PaymentData>.from(json["data"]!.map((x) => PaymentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "page": page,
    "totalPages": totalPages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PaymentData {
  AdvertisementData? advertisement;
  ScreenData? screen;
  num? amount;
  num? amountReceived;
  String? eventType;
  DateTime? createdAt;
  UserData? user;
  num? screenPrice;
  double? platformCharges;
  String? paymentId;

  PaymentData({
    this.advertisement,
    this.screen,
    this.amount,
    this.amountReceived,
    this.eventType,
    this.createdAt,
    this.user,
    this.screenPrice,
    this.platformCharges,
    this.paymentId,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
    advertisement: json["advertisement"] == null ? null : AdvertisementData.fromJson(json["advertisement"]),
    screen: json["screen"] == null ? null : ScreenData.fromJson(json["screen"]),
    user: json["user"] == null ? null : UserData.fromJson(json["user"]),
    amount: json["amount"]?.toDouble(),
    amountReceived: json["amount_received"]?.toDouble(),
    platformCharges: json["platform_charges"]?.toDouble(),
    screenPrice: json["screen_price"],
    eventType: json["event_type"],
    paymentId: json["payment_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "advertisement": advertisement?.toJson(),
    "screen": screen?.toJson(),
    "user": user?.toJson(),
    "amount": amount,
    "amount_received": amountReceived,
    "platform_charges": platformCharges,
    "screen_price": screenPrice,
    "event_type": eventType,
    "payment_id": paymentId,
    "createdAt": createdAt?.toIso8601String(),
  };
}
