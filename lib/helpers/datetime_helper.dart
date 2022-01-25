import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateTimeHelper {
  // RegExp para validação de data
  static RegExp regExpData = RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');

  // Mask input formatters
  static MaskTextInputFormatter dateMaskFormatter =
      MaskTextInputFormatter(mask: '@#/&#/####', filter: {
    '@': RegExp(r'[0-3]'),
    '&': RegExp(r'[01]'),
    '#': RegExp(r'[0-9]'),
  });

  static String retrieveFormattedDateStringBR(DateTime? dateTime) {
    String returnValue;

    returnValue = dateTime == null
        ? 'Data inválida'
        : '${dateTime.day}/${dateTime.month}/${dateTime.year}';

    return returnValue;
  }

  static DateTime dateParse(String date) {
    return DateTime(int.parse(date.substring(6, 10)),
        int.parse(date.substring(3, 5)), int.parse(date.substring(0, 2)));
  }
}
