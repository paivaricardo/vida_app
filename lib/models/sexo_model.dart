class Sexo {
  static String tableName = 'sexo';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `id_sexo`  INTEGER PRIMARY KEY ,
       `dsc_sexo` varchar(45) NOT NULL
      );
  ''';

  static Map<int, String> sexoValues = {
    1: 'M',
    2: 'F',
    3: 'N',
    4: 'O',
  };

  static String prepSQLStringInsertInitialValues = sexoValues.entries.fold(
      'INSERT INTO $tableName (id_sexo, dsc_sexo) VALUES ',
      (previousValue, element) =>
          previousValue + '(${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValues = prepSQLStringInsertInitialValues
          .substring(0, prepSQLStringInsertInitialValues.length - 2) +
      ';';

  static int getSexoId(String sexoValue) {
    return sexoValues.entries
        .firstWhere((element) => element.value == sexoValue)
        .key;
  }

  static String getSexoValue(int sexoId) {
    return sexoValues[sexoId]!;
  }
}
