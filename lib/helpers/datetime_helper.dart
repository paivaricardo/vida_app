class DateTimeHelper {
  static String retriedFormattedDateStringBR(DateTime? dateTime) {
    String returnValue;

    returnValue = dateTime == null ? 'Data inválida' : '${dateTime.day}/${dateTime.month}/${dateTime.year}';

    return returnValue;
  }
}