import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vida_app/models/escolaridade_model.dart';
import 'package:vida_app/models/paciente_conhece_pics.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pics_model.dart';
import 'package:vida_app/models/sexo_model.dart';

class AppDatabase {

  static final String instituicaoTableSQL = '''
    CREATE TABLE `instituicao`
      (
       `id_instituicao`   INTEGER PRIMARY KEY AUTOINCREMENT ,
       `nome_instituicao` varchar(45) NOT NULL
      );
  ''';

  static final String pesquisadorTableSQL = '''
    CREATE TABLE `pesquisador`
      (
       `id_pesquisador`   INTEGER PRIMARY KEY AUTOINCREMENT ,
       `nome_pesquisador` varchar(45) NOT NULL ,
       `id_instituicao`   int NOT NULL ,
      
        FOREIGN KEY (`id_instituicao`) REFERENCES `instituicao` (`id_instituicao`)
      );
  ''';

  static final String intervencaoTableSQL = '''
    CREATE TABLE `intervencao`
      (
       `id_intervencao`       INTEGER PRIMARY KEY AUTOINCREMENT ,
       `datetime_intervencao` varchar(140) NOT NULL ,
       `id_pesquisador`       int NOT NULL ,
       `id_paciente`          int NOT NULL ,
       `id_pic`               int NOT NULL ,
       `duration`             int NOT NULL ,
       `obs_intervencao`      text NOT NULL ,
     
       FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
       FOREIGN KEY (`id_pesquisador`) REFERENCES `pesquisador` (`id_pesquisador`),
       FOREIGN KEY (`id_pic`) REFERENCES `pics` (`id_pic`)
      );
  ''';

  static final String questionariosDomainTableSQl = '''
    CREATE TABLE `questionarios_domain`
      (
       `id_questionario_domain` INTEGER PRIMARY KEY ,
       `nome_questionario`      varchar(140) NOT NULL
      );
  ''';

  static final String questoesQuestionarioDomainTableSQL = '''
    CREATE TABLE `questoes_questionario_domain`
      (
       `id_questao_questionario_domain` INTEGER PRIMARY KEY ,
       `id_questionario_domain`         int NOT NULL ,
       `dsc_questao`                    varchar(45) NOT NULL ,
       `ordem_questao`                  int NOT NULL ,
      
        FOREIGN KEY (`id_questionario_domain`) REFERENCES `questionarios_domain` (`id_questionario_domain`)
      );
  ''';

  static final String questionarioAplicadoTableSQL = '''
    CREATE TABLE `questionario_aplicado`
      (
       `id_questionario_aplicado`    INTEGER PRIMARY KEY AUTOINCREMENT ,
       `data_aplicacao_questionario` varchar(140) NOT NULL ,
       `id_paciente`                 int NOT NULL ,
       `id_questionario_domain`      int NOT NULL ,
       `id_pesquisador`              int NOT NULL ,
       `pontuacao_questionario`      int NULL ,
      
      FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
      FOREIGN KEY (`id_pesquisador`) REFERENCES `pesquisador` (`id_pesquisador`),
      FOREIGN KEY (`id_questionario_domain`) REFERENCES `questionarios_domain` (`id_questionario_domain`)
      );
  ''';

  static final String questionarioQuestaoAplicadaTableSQL = '''
    CREATE TABLE `questionario_questao_aplicada`
      (
       `id_questionario_questao_aplicada` INTEGER PRIMARY KEY AUTOINCREMENT ,
       `id_questionario_aplicado`         int NOT NULL ,
       `id_questao_questionario_domain`   int NOT NULL ,
       `pontuacao_questao`                int NULL ,
      
      FOREIGN KEY (`id_questao_questionario_domain`) REFERENCES `questoes_questionario_domain` (`id_questao_questionario_domain`),
      FOREIGN KEY (`id_questionario_aplicado`) REFERENCES `questionario_aplicado` (`id_questionario_aplicado`)
      );
  ''';



  static Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'vidaapp.db');
    return openDatabase(
      path,
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
      onCreate: (Database db, version) async {

        // final String databasesTableString = '''
        //   ${Sexo.tableSQL}\n
        //   ${Escolaridade.tableSQL}\n
        //   ${Paciente.tableSQL}\n
        //   $instituicaoTableSQL\n
        //   $pesquisadorTableSQL\n
        //   $picsTableSQL\n
        //   $pacienteConhecePicsTableSQL\n
        //   $intervencaoTableSQL\n
        //   $questionariosDomainTableSQl\n
        //   $questoesQuestionarioDomainTableSQL\n
        //   $questionarioAplicadoTableSQL\n
        //   $questionarioQuestaoAplicadaTableSQL\n
        // ''';

        await db.execute(Sexo.tableSQL);
        await db.execute(Escolaridade.tableSQL);
        await db.execute(Paciente.tableSQL);
        await db.execute(Pics.tableSQL);
        await db.execute(instituicaoTableSQL);
        await db.execute(pesquisadorTableSQL);
        await db.execute(PacienteConhecePics.tableSQL);
        await db.execute(intervencaoTableSQL);
        await db.execute(questionariosDomainTableSQl);
        await db.execute(questoesQuestionarioDomainTableSQL);
        await db.execute(questionarioAplicadoTableSQL);
        await db.execute(questionarioQuestaoAplicadaTableSQL);

      //  Inicializar valores nas tabelas de domínio
        await db.transaction((txn) async {

          await txn.rawInsert(Sexo.SQLStringInsertInitialValues);
          await txn.rawInsert(Escolaridade.SQLStringInsertInitialValues);
          await txn.rawInsert(Pics.SQLStringInsertInitialValues);
        });

      },
    );
  }
}
