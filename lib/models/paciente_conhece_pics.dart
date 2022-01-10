class PacienteConhecePics {
  static String tableName = 'paciente_conhece_pics';

  static String tableSQL = '''
    CREATE TABLE `paciente_conhece_pics`
      (
       `id_paciente_conhece_pics` INTEGER PRIMARY KEY AUTOINCREMENT ,
       `id_paciente`              int NOT NULL ,
       `id_pic`                   int NOT NULL ,
    
        FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
        FOREIGN KEY (`id_pic`) REFERENCES `pics` (`id_pic`)
      );
  ''';

}