import 'package:vida_app/local_database/dao/questionario_dao.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questionario_model.dart';

class SnippetListRetrieverHelper {

  static Future<List<dynamic>> retrieveSnippetList(Paciente paciente) async {
    QuestionarioDAO _questionarioDAO = QuestionarioDAO();

    List<dynamic> snippetList = [];

    final List<Questionario> listQuestionarios = await _questionarioDAO.retriveQuestionariosPaciente(paciente);
    // TODO: implementar lista de intervenções

    listQuestionarios.forEach((questionario) => snippetList.add(questionario));

    snippetList.sort((a, b) => a.dataRealizacao.compareTo(b.dataRealizacao));

    return snippetList;
  }

}