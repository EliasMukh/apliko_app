class UserModel {
  UserModel({
    required this.id,
    this.createdAt,
    this.name,
    this.token,
    this.email,
    this.dateOfBirth,
    this.subscription,
    this.refreshToken,
    this.fcmToken,
  });

  /// used in consultancy message feature to determine if user already pay and now he can send message
  final String id;
  final DateTime? createdAt;
  DateTime? dateOfBirth;
  String? name, token, email, refreshToken, fcmToken;
  bool? subscription;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null,
      name: json['name'],
      token: json['auth_token'],
      email: json['email'],
      refreshToken: json['refreshToken'],
      fcmToken: json['fcmToken'],
      subscription: json['subscription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'name': name,
      'auth_token': token,
      'email': email,
      'refreshToken': refreshToken,
      'fcmToken': fcmToken,
      'subscription': subscription,
    };
  }
}
