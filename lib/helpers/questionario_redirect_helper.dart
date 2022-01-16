import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/database/dao/questionario_ansiedade_dao.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/screens/questionario_ansiedade/resultado_questionario_ansiedade_screen.dart';

class QuestionarioRedirectHelper {
  static Future<void> redirectQuestionario(
      Questionario questionario, BuildContext context) async {
    switch (questionario.idQuestionarioDomain) {
      case QuestionarioDomain.ansiedadeBAIDomainValue:
        QuestionarioAnsiedadeDAO _questionarioAnsiedadeDAO =
            QuestionarioAnsiedadeDAO();

        QuestionarioAnsiedade questionarioAnsiedade =
            await _questionarioAnsiedadeDAO
                .retrieveQuestionarioAnsiedade(questionario);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResultadoQuestionarioAnsiedadeScreen(
                  questionario: questionarioAnsiedade,
                )));
    }
  }
}
