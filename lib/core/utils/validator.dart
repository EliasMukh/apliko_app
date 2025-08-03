bool isPasswordStrong(String? str) => RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)").hasMatch(str ?? '');

bool isNumber(String? str) => RegExp(r'[0-9]').hasMatch(str ?? '');

bool isEmail(String? str) => RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
    .hasMatch(str ?? '');

enum Validator {
  email(isEmail),
  password(isPasswordStrong),
  number(isNumber),
  ;

  const Validator(this.isValid);

  final bool Function(String?) isValid;
}
