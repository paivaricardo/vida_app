class TipoInstiuicaoDomain {
  static String tableName = 'tipo_instituicao_domain';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `id_tipo_instituicao` integer NOT NULL ,
       `tipo_instituicao`    text NOT NULL ,
      
      PRIMARY KEY (`id_tipo_instituicao`)
      );
  ''';

  static Map<int, String> tipoInstituicaoValues = {
    1: 'Instituição de Ensino Superior',
    2: 'Unidade de Saúde',
    3: 'Centro de Pesquisa',
    4: 'Outro Órgão Governamental',
    5: 'Outro',
  };

  static String prepSQLStringInsertInitialValues = tipoInstituicaoValues.entries.fold(
      'INSERT INTO $tableName (id_tipo_instituicao, tipo_instituicao) VALUES ',
          (previousValue, element) =>
      previousValue + '(${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValues = prepSQLStringInsertInitialValues
      .substring(0, prepSQLStringInsertInitialValues.length - 2) +
      ';';

  static int getTipoInstituicaoId(String sexoValue) {
    return tipoInstituicaoValues.entries
        .firstWhere((element) => element.value == sexoValue)
        .key;
  }

  static String getTipoInstituicaoValue(int sexoId) {
    return tipoInstituicaoValues[sexoId]!;
  }
}