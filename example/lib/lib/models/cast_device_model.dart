class CastDeviceModel {
  String? id;
  String? name;
  String? description;
  String? uri;
  bool? enable;

  CastDeviceModel({
    this.id,
    this.name,
    this.description,
    this.enable,
    this.uri,
  });

  factory CastDeviceModel.fromJson(Map<String, dynamic> json) {
    return CastDeviceModel(
      id: json['id'] ?? '',
      uri: json['uri'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      enable: json['enable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'uri': uri,
      'description': description,
      'enable': enable,
    };
  }
}
