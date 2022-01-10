class Pics {
  static String tableName = 'pics';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `id_pic`   INTEGER PRIMARY KEY ,
       `nome_pic` varchar(45) NOT NULL
      );
  ''';

  static Map<int, String> picsValues = {
    1: 'Reflexologia podal',
    2: 'Aromaterapia',
    3: 'Auriculoterapia',
    4: 'Cromoterapia',
  };

  static String prepSQLStringInsertInitialValues = picsValues.entries.fold(
      'INSERT INTO $tableName (id_pic, nome_pic) VALUES ',
          (previousValue, element) =>
      previousValue + '(${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValues = prepSQLStringInsertInitialValues
      .substring(0, prepSQLStringInsertInitialValues.length - 2) +
      ';';

  static int getPicId(String picValue) {
    return picsValues.entries
        .firstWhere((element) => element.value == picValue)
        .key;
  }

  static String getPicValue(int picId) {
    return picsValues[picId]!;
  }
}