// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  dynamic status;
  dynamic code;
  dynamic message;
  Error? error;

  ErrorModel({
    this.status,
    this.code,
    this.message,
    this.error,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        status: json["status"],
        code: json["code"],
        message: (json["message"] != null &&json["message"].runtimeType == String) ? json["message"] : null,
        error: (json["error"] != null && json["error"].runtimeType != String)
            ? Error.fromJson(json["error"]):null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "error_string": message,
        "error": error?.toJson(),
      };
}

class Error {
  String? message;

  Error({
    this.message,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
