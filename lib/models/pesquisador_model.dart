class Pesquisador {
  static String tableName = 'pesquisador';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_pesquisador`  text NOT NULL ,
       `nome_pesquisador`  text NOT NULL ,
       `uuid_instituicao`  text NOT NULL ,
       `cpf_pesquisador`   text NOT NULL ,
       `cargo_pesquisador` text NOT NULL ,
      
      PRIMARY KEY (`uuid_pesquisador`),
      FOREIGN KEY (`uuid_instituicao`) REFERENCES `instituicao` (`uuid_instituicao`)
      );
  ''';

}