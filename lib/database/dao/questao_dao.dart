import 'package:sqflite/sqflite.dart';
import 'package:vida_app/database/app_database.dart';
import 'package:vida_app/models/questao_model.dart';

class QuestaoDAO {
  static final _tableName = Questao.tableName;

  Future<List<int>> saveAll(Map<int, Questao> questoes) async {

    return await Future.wait(questoes.values.map((questao) async => await save(questao)));

  }

  Future<int> save(Questao questao) async {
    final Database db = await AppDatabase.getDatabase();
    Map<String, dynamic> questaoMap = _toMap(questao);

    return db.insert(_tableName, questaoMap);
  }

  Map<String, dynamic> _toMap(Questao questao) {
    final Map<String, dynamic> questaoMap = Map();

    questaoMap['uuid_questionario_aplicado'] = questao.questionario.uuidQuestionarioAplicado;
    questaoMap['id_questao_questionario_domain'] = questao.idQuestaoQuestionarioDomain;
    questaoMap['pontuacao_questao'] = questao.pontuacao;

    return questaoMap;
  }
}
