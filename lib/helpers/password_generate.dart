import 'dart:math';
import 'dart:convert';

class PasswordGenerate {
  static String generatePassword({int length = 8}) {
    return base64Url.encode(
        List<int>.generate(length, (index) => Random.secure().nextInt(256)));
  }
}
