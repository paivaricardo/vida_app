import 'dart:core';
import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:vida_app/local_database/app_database.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_model.dart';

class QuestionarioDAO {
  static final _tableName = Questionario.tableName;

  Future<List<Questionario>> retriveQuestionariosPaciente(Paciente paciente) async {
    final Database db = await AppDatabase.getDatabase();

    List<Questionario> questionariosList = await _retrieveListPaciente(db, paciente);

    return questionariosList;
  }

  Future<int> save(Questionario questionarioGeral) async {
    final Database db = await AppDatabase.getDatabase();

    Map<String, dynamic> questionarioGeralMap = _toMap(questionarioGeral);

    return db.insert(_tableName, questionarioGeralMap);
  }

  Map<String, dynamic> _toMap(Questionario questionarioGeral) {
    final Map<String, dynamic> questionarioAnsiedadeMap = Map();

    questionarioAnsiedadeMap['uuid_questionario_aplicado'] = questionarioGeral.uuidQuestionarioAplicado;
    questionarioAnsiedadeMap['data_aplicacao_questionario'] = questionarioGeral.dataRealizacao.toString();
    questionarioAnsiedadeMap['pontuacao_questionario'] = questionarioGeral.pontuacaoQuestionario;
    questionarioAnsiedadeMap['uuid_paciente'] = questionarioGeral.paciente.uuid;
    questionarioAnsiedadeMap['id_questionario_domain'] = questionarioGeral.idQuestionarioDomain;
    questionarioAnsiedadeMap['uuid_pesquisador'] = questionarioGeral.uuidPesquisador;

    return questionarioAnsiedadeMap;
  }

  Future<List<Questionario>> _retrieveListPaciente(Database db, Paciente paciente) async {
    List<Questionario> questionariosList = [];

    // final List<Map<String, dynamic>> result = await db.query(_tableName, where: 'uuid_paciente = \'?\'', whereArgs: [paciente.uuid]);
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $_tableName WHERE uuid_paciente = \'${paciente.uuid}\' AND ic_active = 1');

    result.forEach((row) {
      Questionario retrievedQuestionario = Questionario(
        idQuestionarioDomain: int.parse(row['id_questionario_domain'].toString()),
        paciente: paciente
      );

      retrievedQuestionario.uuidQuestionarioAplicado = row['uuid_questionario_aplicado'];
      retrievedQuestionario.dataRealizacao = DateTime.parse(row['data_aplicacao_questionario'].toString());
      retrievedQuestionario.pontuacaoQuestionario = int.parse(row['pontuacao_questionario'].toString());
      retrievedQuestionario.uuidPesquisador = row['uuidPesquisador'];

      questionariosList.add(retrievedQuestionario);

    });

    return questionariosList;
  }

}
