class RecoverPasswordParams {
  final String email;

  RecoverPasswordParams({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class SubmitRecoverPasswordParams {
  final String code;
  final String newPassword;

  SubmitRecoverPasswordParams({required this.code, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'code': code, 'new_password': newPassword};
  }
}
