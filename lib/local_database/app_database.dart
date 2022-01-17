import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vida_app/models/escolaridade_model.dart';
import 'package:vida_app/models/instituicao_model.dart';
import 'package:vida_app/models/intervencao_model.dart';
import 'package:vida_app/models/paciente_conhece_pic.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/paciente_pesquisador_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/pic_model.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/models/sexo_model.dart';
import 'package:vida_app/models/tipo_instituicao_domain_model.dart';

class AppDatabase {

  static Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'vidaapp.db');
    return openDatabase(
      path,
      version: 1,
      onDowngrade: onDatabaseDowngradeDelete,
      onCreate: (Database db, version) async {

        await db.execute(Sexo.tableSQL);
        await db.execute(Escolaridade.tableSQL);
        await db.execute(Pesquisador.tableSQL);
        await db.execute(Paciente.tableSQL);
        await db.execute(PacientePesquisador.tableSQL);
        await db.execute(Pic.tableSQL);
        await db.execute(TipoInstiuicaoDomain.tableSQL);
        await db.execute(Instituicao.tableSQL);
        await db.execute(PacienteConhecePic.tableSQL);
        await db.execute(Intervencao.tableSQL);
        await db.execute(QuestionarioDomain.tableSQL);
        await db.execute(QuestaoQuestionarioDomain.tableSQL);
        await db.execute(Questionario.tableSQL);
        await db.execute(QuestionarioAnsiedade.tableSQL);
        await db.execute(Questao.tableSQL);

      //  Inicializar valores nas tabelas de domínio
        await db.transaction((txn) async {

          await txn.rawInsert(Sexo.SQLStringInsertInitialValues);
          await txn.rawInsert(Escolaridade.SQLStringInsertInitialValues);
          await txn.rawInsert(Pic.SQLStringInsertInitialValues);
          await txn.rawInsert(TipoInstiuicaoDomain.SQLStringInsertInitialValues);
          await txn.rawInsert(QuestionarioDomain.SQLStringInsertInitialValues);

          // Inserir valores de domínio relativos às questões de cada questionário
          await txn.rawInsert(QuestaoQuestionarioDomain.SQLStringInsertInitialValuesAnsiedade);

        });

      },
    );
  }
}
