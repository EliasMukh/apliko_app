class AuthParams {
  String? email;
  String? password;
  String? firstname;
  String? lastname;

  // كونستركتور خاص بالتسجيل (Signup)
  AuthParams.signup({this.email, this.password, this.firstname, this.lastname});

  AuthParams.login({this.email, this.password})
    : firstname = null,
      lastname = null;

  Map<String, dynamic> toJson() {
    final map = {'email': email, 'password': password};

    if (firstname != null) map['first_name'] = firstname!;
    if (lastname != null) map['last_name'] = lastname!;
    return map;
  }
}
