class Escolaridade {
  static String tableName = 'escolaridade';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
        `id_escolaridade`   INTEGER PRIMARY KEY ,
        `nome_escolaridade` varchar(45) NOT NULL
      );
  ''';

  static Map<int, String> escolaridadeValues = {
    1: 'Fundamental - Incompleto',
    2: 'Fundamental - Completo',
    3: 'Médio - Incompleto',
    4: 'Médio - Completo',
    5: 'Superior - Incompleto',
    6: 'Superior - Completo',
    7: 'Pós-graduação (Lato senso) - Incompleto',
    8: 'Pós-graduação (Lato senso) - Completo',
    9: 'Pós-graduação (Stricto sensu, nível mestrado) - Incompleto',
    10: 'Pós-graduação (Stricto sensu, nível mestrado) - Completo',
    11: 'Pós-graduação (Stricto sensu, nível doutor) - Incompleto',
    12: 'Pós-graduação (Stricto sensu, nível doutor) - Completo',
    13: 'Ignorado',
  };

  static String prepSQLStringInsertInitialValues = escolaridadeValues.entries
      .fold(
          'INSERT INTO $tableName(id_escolaridade, nome_escolaridade) VALUES ',
          (previousValue, element) =>
              previousValue + '(${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValues = prepSQLStringInsertInitialValues
          .substring(0, prepSQLStringInsertInitialValues.length - 2) +
      ';';

  static int getEscolaridadeId(String escolaridadeValue) {
    return escolaridadeValues.entries
        .firstWhere((element) => element.value == escolaridadeValue)
        .key;
  }

  static String getEscolaridadeValue(int escolaridadeId) {
    return escolaridadeValues[escolaridadeId]!;
  }
}
