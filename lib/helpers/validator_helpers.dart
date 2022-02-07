class ValidatorHelpers {

  static RegExp emailRegExp = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  static String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return 'O campo não pode estar em branco.';
    } else if (emailRegExp.hasMatch(email)) {
      return null;
    } else {
      return 'E-mail com formato inválido.';
    }
  }
}