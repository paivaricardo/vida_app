import 'package:sqflite/sqflite.dart';
import 'package:vida_app/local_database/app_database.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';

// class QuestaoDAO {
//   static final _tableName = Questao.tableName;
//   static final _questaoDomaintableName = QuestaoQuestionarioDomain.tableName;
//
//   Future<List<int>> saveAll(Map<int, Questao> questoes) async {
//     return await Future.wait(
//         questoes.values.map((questao) async => await save(questao)));
//   }
//
//   Future<int> save(Questao questao) async {
//     final Database db = await AppDatabase.getDatabase();
//     Map<String, dynamic> questaoMap = _toMap(questao);
//
//     return db.insert(_tableName, questaoMap);
//   }
//
//   Map<String, dynamic> _toMap(Questao questao) {
//     final Map<String, dynamic> questaoMap = Map();
//
//     questaoMap['uuid_questionario_aplicado'] =
//         questao.questionario.uuidQuestionarioAplicado;
//     questaoMap['id_questao_questionario_domain'] =
//         questao.idQuestaoQuestionarioDomain;
//     questaoMap['pontuacao_questao'] = questao.pontuacao;
//
//     return questaoMap;
//   }
//
//   Future<Map<int, Questao>> retrieveQuestoes(
//       Questionario questionario, Database db) async {
//     final List<Map<String, dynamic>> result = await db.rawQuery(
//         'SELECT * FROM $_tableName INNER JOIN $_questaoDomaintableName ON $_tableName.id_questao_questionario_domain = $_questaoDomaintableName.id_questao_questionario_domain WHERE uuid_questionario_aplicado = \'${questionario.uuidQuestionarioAplicado}\'');
//     Map<int, Questao> retrievedQuestoes = Map();
//
//     result.forEach((row) {
//       int ordemQuestao = int.parse(row['ordem_questao'].toString());
//
//       retrievedQuestoes[ordemQuestao] = Questao(questionario, ordemQuestao);
//       retrievedQuestoes[ordemQuestao]!.pontuacao =
//           int.parse(row['pontuacao_questao'].toString());
//     });
//
//     return retrievedQuestoes;
//   }
// }
