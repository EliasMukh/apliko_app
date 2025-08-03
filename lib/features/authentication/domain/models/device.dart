class DeviceModel {
  DeviceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.params,
    required this.userAccessLevel,
  });

  final String id;
  String name;
  String description;
  String status;
  Map<String, dynamic> params;
  String userAccessLevel;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',

      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      params:
          json['params'] is Map
              ? Map<String, dynamic>.from(json['params'])
              : {},
      userAccessLevel: json['user_access_level'] ?? '', // إضافة القيمة من JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'params': params,
      'user_access_level': userAccessLevel, // إضافة القيمة إلى JSON
    };
  }
}
