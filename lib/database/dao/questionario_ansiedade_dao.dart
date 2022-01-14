import 'package:sqflite/sqflite.dart';
import 'package:vida_app/database/app_database.dart';
import 'package:vida_app/database/dao/questionario_dao.dart';
import 'package:vida_app/database/dao/questao_dao.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questao_model.dart';

class QuestionarioAnsiedadeDAO {
  static final _tableName = QuestionarioAnsiedade.tableName;

  // Este save já salva tuplas referentes ao questionário de ansiedade em 3 tabelas: questionario_ansiedade, questionario_aplicado e questao_questionario_aplicada
  Future<int> save(QuestionarioAnsiedade questionarioAnsiedade) async {
    final Database db = await AppDatabase.getDatabase();

    final QuestionarioDAO _questionarioDAO = QuestionarioDAO();
    final QuestaoDAO _questaoDAO = QuestaoDAO();

    // Primeiro: salvar o questionário geral (superclasse)
    // Passando a instância de QuestionarioAnsiedade com Questionario (Princípio da substituição de Liskov)
    await _questionarioDAO.save(questionarioAnsiedade);

    // Segundo: salvar cada questão individualmente na tabela de questões (questao_questionario_aplicada)
    await _questaoDAO.saveAll(questionarioAnsiedade.questoes);

    // Primeiro: salvar o questionário específico de ansiedade (subclasse)
    Map<String, dynamic> questionarioAnsiedadeMap = _toMap(questionarioAnsiedade);

    return db.insert(_tableName, questionarioAnsiedadeMap);
  }

  Map<String, dynamic> _toMap(QuestionarioAnsiedade questionarioAnsiedade) {
    final Map<String, dynamic> questionarioAnsiedadeMap = Map();

    questionarioAnsiedadeMap['uuid_questionario_aplicado'] = questionarioAnsiedade.uuidQuestionarioAplicado;
    questionarioAnsiedadeMap['possui_diagnostico_ansiedade'] = questionarioAnsiedade.possuiDiagnosticoAnsiedade;
    questionarioAnsiedadeMap['desde_quando_possui_diag'] = questionarioAnsiedade.desdeQuandoPossuiDiag.toString();
    questionarioAnsiedadeMap['ja_encontra_tratamento'] = questionarioAnsiedade.jaEncontraTratamento.toString();
    questionarioAnsiedadeMap['tempo_tratamento'] = questionarioAnsiedade.tempoTratamento;
    questionarioAnsiedadeMap['tratamento_atual_ansiedade'] = questionarioAnsiedade.tratamentoAtualAnsiedade;
    questionarioAnsiedadeMap['tratamentos_previos_ansiedade'] = questionarioAnsiedade.tratamentosPreviosAnsiedade;

    return questionarioAnsiedadeMap;
  }

}