class PacienteConhecePic {
  static String tableName = 'paciente_conhece_pic';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_paciente` text NOT NULL ,
       `id_pic`        integer NOT NULL ,
      
      PRIMARY KEY (`uuid_paciente`, `id_pic`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`),
      FOREIGN KEY (`id_pic`) REFERENCES `pic` (`id_pic`)
      );
  ''';

}