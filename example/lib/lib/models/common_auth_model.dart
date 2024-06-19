// To parse this JSON data, do
//
//     final commonAuthModel = commonAuthModelFromJson(jsonString);

import 'dart:convert';

import 'package:sample/models/profile_model.dart';

CommonAuthModel commonAuthModelFromJson(String str) =>
    CommonAuthModel.fromJson(json.decode(str));

String commonAuthModelToJson(CommonAuthModel data) =>
    json.encode(data.toJson());

class CommonAuthModel {
  dynamic otp;
  dynamic token;
  dynamic message;
  dynamic userRole;
  UserData? userData;

  CommonAuthModel({
    this.otp,
    this.token,
    this.message,
    this.userRole,
    this.userData,
  });

  factory CommonAuthModel.fromJson(Map<String, dynamic> json) =>
      CommonAuthModel(
        otp: json["otp"],
        token: json["token"],
        message: json["message"],
        userRole: json["user_role"],
        userData: json["userData"] == null
            ? null
            : UserData.fromJson(json["userData"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "otp": otp,
        "token": token,
        "message": message,
        "user_role": userRole,
        "userData": userData?.toJson(),
      };
}
