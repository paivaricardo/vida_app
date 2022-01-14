import 'package:sqflite/sqflite.dart';
import 'package:vida_app/database/app_database.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_model.dart';

class QuestionarioDAO {
  static final _tableName = Questionario.tableName;


  Future<int> save(Questionario questionarioGeral) async {
    final Database db = await AppDatabase.getDatabase();

    Map<String, dynamic> questionarioGeralMap = _toMap(questionarioGeral);

    return db.insert(_tableName, questionarioGeralMap);
  }

  Map<String, dynamic> _toMap(Questionario questionarioGeral) {
    final Map<String, dynamic> questionarioAnsiedadeMap = Map();

    questionarioAnsiedadeMap['uuid_questionario_aplicado'] = questionarioGeral.uuidQuestionarioAplicado;
    questionarioAnsiedadeMap['data_aplicacao_questionario'] = questionarioGeral.dataAplicacaoQuestionario.toString();
    questionarioAnsiedadeMap['pontuacao_questionario'] = questionarioGeral.pontuacaoQuestionario;
    questionarioAnsiedadeMap['uuid_paciente'] = questionarioGeral.paciente.uuid;
    questionarioAnsiedadeMap['id_questionario_domain'] = questionarioGeral.idQuestionarioDomain;
    questionarioAnsiedadeMap['uuid_pesquisador'] = questionarioGeral.uuidPesquisador;

    return questionarioAnsiedadeMap;
  }

}
