class Instituicao {
  static String tableName = 'instituicao';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_instituicao`    text NOT NULL ,
       `nome_instituicao`    text NOT NULL ,
       `id_tipo_instituicao` integer NOT NULL ,
      
      PRIMARY KEY (`uuid_instituicao`),
      FOREIGN KEY (`id_tipo_instituicao`) REFERENCES `tipo_instituicao_domain` (`id_tipo_instituicao`)
      );
  ''';

}