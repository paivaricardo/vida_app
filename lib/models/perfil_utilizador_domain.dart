class PerfilUtilizador {
  static String tableName = 'perfil_utilizador_domain';

  static String tableSQL = '''
    CREATE TABLE `perfil_utilizador_domain`
      (
       `id_perfil_utilizador`   integer NOT NULL ,
       `tipo_perfil_utilizador` text NOT NULL ,
      
      PRIMARY KEY (`id_perfil_utilizador`)
      );
  ''';

  static Map<int, String> perfilUtilizadorValues = {
    1: 'Coordenador',
    2: 'Mestrando',
    3: 'Iniciação Científica',
    4: 'Estagiário',
  };

  static String prepSQLStringInsertInitialValues = perfilUtilizadorValues.entries
      .fold(
          'INSERT INTO $tableName(id_perfil_utilizador, tipo_perfil_utilizador) VALUES ',
          (previousValue, element) =>
              previousValue + '(${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValues = prepSQLStringInsertInitialValues
          .substring(0, prepSQLStringInsertInitialValues.length - 2) +
      ';';

  static int getPerfilUtilizadorId(String perfilUtilizadorValue) {
    return perfilUtilizadorValues.entries
        .firstWhere((element) => element.value == perfilUtilizadorValue)
        .key;
  }

  static String getPerfilUtilizadorValue(int perfilUtilizadorId) {
    return perfilUtilizadorValues[perfilUtilizadorId]!;
  }
}
