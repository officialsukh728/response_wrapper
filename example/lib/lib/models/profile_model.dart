// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? statusCode;
  String? message;
  UserData? userData;

  ProfileModel({
    this.statusCode,
    this.message,
    this.userData,
  });

  ProfileModel copyWith({
    int? statusCode,
    String? message,
    UserData? userData,
  }) =>
      ProfileModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        userData: userData ?? this.userData,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    statusCode: json["statusCode"],
    message: json["message"],
    userData: json["userData"] == null ? null : UserData.fromJson(json["userData"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "userData": userData?.toJson(),
  };
}

class UserData {
  String? id;
  String? name;
  String? email;
  String? password;
  String? userRole;
  String? activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? stripeConnect;
  String? stripeResponse;
  int? phone;
  String? photo;
  bool? socialLogin;
  dynamic address;
  dynamic latitude;
  dynamic longitude;
  dynamic userId;
  EarnerLocation? earnerLocation;

  UserData({
    this.id,
    this.name,
    this.email,
    this.password,
    this.userRole,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.stripeConnect,
    this.stripeResponse,
    this.phone,
    this.photo,
    this.socialLogin,
    this.address,
    this.latitude,
    this.longitude,
    this.userId,
    this.earnerLocation,
  });

  UserData copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? userRole,
    String? activeStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    String? stripeConnect,
    String? stripeResponse,
    int? phone,
    String? photo,
    bool? socialLogin,
    dynamic address,
    dynamic latitude,
    dynamic longitude,
    dynamic userId,
    EarnerLocation? earnerLocation,
  }) =>
      UserData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        userRole: userRole ?? this.userRole,
        activeStatus: activeStatus ?? this.activeStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        stripeConnect: stripeConnect ?? this.stripeConnect,
        stripeResponse: stripeResponse ?? this.stripeResponse,
        phone: phone ?? this.phone,
        photo: photo ?? this.photo,
        socialLogin: socialLogin ?? this.socialLogin,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        userId: userId ?? this.userId,
        earnerLocation: earnerLocation ?? this.earnerLocation,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    userRole: json["user_role"],
    activeStatus: json["active_status"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    stripeConnect: json["stripe_connect"],
    stripeResponse: json["stripe_response"],
    phone: json["phone"],
    photo: json["photo"],
    socialLogin: json["social_login"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    userId: json["user_id"],
    earnerLocation: json["earnerLocation"] == null ? null : EarnerLocation.fromJson(json["earnerLocation"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "password": password,
    "user_role": userRole,
    "active_status": activeStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "stripe_connect": stripeConnect,
    "stripe_response": stripeResponse,
    "phone": phone,
    "photo": photo,
    "social_login": socialLogin,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "user_id": userId,
    "earnerLocation": earnerLocation?.toJson(),
  };
}

class EarnerLocation {
  String? id;
  String? userId;
  String? address;
  double? latitude;
  double? longitude;
  String? zipCode;
  String? state;
  String? buildingNumber;
  String? street;
  String? city;
  String? nearbyAddress;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  EarnerLocation({
    this.id,
    this.userId,
    this.address,
    this.latitude,
    this.longitude,
    this.zipCode,
    this.state,
    this.buildingNumber,
    this.street,
    this.city,
    this.nearbyAddress,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  EarnerLocation copyWith({
    String? id,
    String? userId,
    String? address,
    double? latitude,
    double? longitude,
    String? zipCode,
    String? state,
    String? buildingNumber,
    String? street,
    String? city,
    String? nearbyAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      EarnerLocation(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        zipCode: zipCode ?? this.zipCode,
        state: state ?? this.state,
        buildingNumber: buildingNumber ?? this.buildingNumber,
        street: street ?? this.street,
        city: city ?? this.city,
        nearbyAddress: nearbyAddress ?? this.nearbyAddress,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory EarnerLocation.fromJson(Map<String, dynamic> json) => EarnerLocation(
    id: json["_id"],
    userId: json["userId"],
    address: json["address"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    zipCode: json["zip_code"],
    state: json["state"],
    buildingNumber: json["building_number"],
    street: json["street"],
    city: json["city"],
    nearbyAddress: json["nearby_address"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "zip_code": zipCode,
    "state": state,
    "building_number": buildingNumber,
    "street": street,
    "city": city,
    "nearby_address": nearbyAddress,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
