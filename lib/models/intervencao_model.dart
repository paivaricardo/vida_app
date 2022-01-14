class Intervencao {
  static String tableName = 'intervencao';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_intervencao`     text NOT NULL ,
       `datetime_intervencao` text NOT NULL ,
       `uuid_pesquisador`     text NOT NULL ,
       `uuid_paciente`        text NOT NULL ,
       `id_pic`               integer NOT NULL ,
       `duration`             integer NOT NULL ,
       `obs_intervencao`      text NOT NULL ,
      
      PRIMARY KEY (`uuid_intervencao`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`),
      FOREIGN KEY (`uuid_pesquisador`) REFERENCES `pesquisador` (`uuid_pesquisador`),
      FOREIGN KEY (`id_pic`) REFERENCES `pic` (`id_pic`)
      );
  ''';

}