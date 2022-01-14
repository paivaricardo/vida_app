class PacientePesquisador {
  static final String tableName = 'paciente_pesquisador';

  static final String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_pesquisador`             text NOT NULL ,
       `uuid_paciente`                text NOT NULL ,
       `titular`                      text NOT NULL ,
       `data_inicio_titular`          text NULL ,
       `data_fim_titular`             text NULL ,
       `data_inicio_compartilhamento` text NULL ,
       `data_fim_compartilhamento`    text NULL ,
      
      PRIMARY KEY (`uuid_pesquisador`, `uuid_paciente`),
      FOREIGN KEY (`uuid_pesquisador`) REFERENCES `pesquisador` (`uuid_pesquisador`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`)
      );
  ''';
}