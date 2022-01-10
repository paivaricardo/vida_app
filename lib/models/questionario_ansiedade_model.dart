import 'package:vida_app/models/numeric_score_question_model.dart';

class QuestionarioAnsiedadeModel {
  int pontuacaoTotal = 0;
  DateTime? dataRegistroQuestionario;
  String? interpretacaoScoreBAI;

  QuestionarioAnsiedadeModel();

  Map<int, NumericScoreAnsiedadeQuestion> questoes = {
    1: NumericScoreAnsiedadeQuestion('1. Dormência ou formigamento'),
    2: NumericScoreAnsiedadeQuestion('2. Sensação de calor'),
    3: NumericScoreAnsiedadeQuestion('3. Tremores nas pernas'),
    4: NumericScoreAnsiedadeQuestion('4. Incapaz de relaxar'),
    5: NumericScoreAnsiedadeQuestion('5. Medo que aconteça o pior'),
    6: NumericScoreAnsiedadeQuestion('6. Atordoado ou tonto'),
    7: NumericScoreAnsiedadeQuestion('7. Palpitação ou aceleração do coração'),
    8: NumericScoreAnsiedadeQuestion('8. Sem equilíbrio'),
    9: NumericScoreAnsiedadeQuestion('9. Aterrorizado'),
    10: NumericScoreAnsiedadeQuestion('10. Nervoso'),
    11: NumericScoreAnsiedadeQuestion('11. Sensação de sufocação'),
    12: NumericScoreAnsiedadeQuestion('12. Tremores nas mãos'),
    13: NumericScoreAnsiedadeQuestion('13. Trêmulo'),
    14: NumericScoreAnsiedadeQuestion('14. Medo de perder o controle'),
    15: NumericScoreAnsiedadeQuestion('15. Dificuldade de respirar'),
    16: NumericScoreAnsiedadeQuestion('16. Medo de morrer'),
    17: NumericScoreAnsiedadeQuestion('17. Assustado'),
    18: NumericScoreAnsiedadeQuestion(
        '18. Indigestão ou desconforto no abdômen'),
    19: NumericScoreAnsiedadeQuestion('19. Sensação de desmaio'),
    20: NumericScoreAnsiedadeQuestion('20. Rosto afogueado'),
    21: NumericScoreAnsiedadeQuestion('21. Suor (não devido ao calor)'),
  };

// Reference code for generating maps with iterables:
// Map<int, TextEditingController> controllersQuestoes = Map<int, TextEditingController>.fromIterable(List.generate(21, (index) => index), key: (item) => int.parse(item), value: (item) => TextEditingController());
// Map<int, TextEditingController> controllersQuestoes = {
//   for (var item in List<int>.generate(21, (index) => index + 1))
//     item: TextEditingController()
// };

  void registrarInterpretacaoScoreBAI(int pontuacaoTotal) {
    if(pontuacaoTotal <= 7) {
      interpretacaoScoreBAI = 'Grau mínimo de ansiedade';
    } else if(pontuacaoTotal <= 15) {
      interpretacaoScoreBAI = 'Ansiedade leve';
    } else if(pontuacaoTotal <= 25) {
      interpretacaoScoreBAI = 'Ansiedade moderada';
    } else {
      interpretacaoScoreBAI = 'Ansiedade grave';
    }
  }

}
