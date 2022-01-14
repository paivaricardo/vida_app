import 'package:vida_app/models/questionario_domain_model.dart';

class QuestaoQuestionarioDomain {
  static String tableName = 'questao_questionario_domain';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `id_questao_questionario_domain` integer NOT NULL ,
       `id_questionario_domain`         integer NOT NULL ,
       `ordem_questao`                  integer NOT NULL ,
       `dsc_questao`                    text NOT NULL ,
      
      PRIMARY KEY (`id_questao_questionario_domain`),
      FOREIGN KEY (`id_questionario_domain`) REFERENCES `questionario_domain` (`id_questionario_domain`)
      );
  ''';

  static Map<int, String> questionarioAnsiedadeQuestoesValues = {
    1: 'Dormência ou formigamento',
    2: 'Sensação de calor',
    3: 'Tremores nas pernas',
    4: 'Incapaz de relaxar',
    5: 'Medo que aconteça o pior',
    6: 'Atordoado ou tonto',
    7: 'Palpitação ou aceleração do coração',
    8: 'Sem equilíbrio',
    9: 'Aterrorizado',
    10: 'Nervoso',
    11: 'Sensação de sufocação',
    12: 'Tremores nas mãos',
    13: 'Trêmulo',
    14: 'Medo de perder o controle',
    15: 'Dificuldade de respirar',
    16: 'Medo de morrer',
    17: 'Assustado',
    18: 'Indigestão ou desconforto no abdômen',
    19: 'Sensação de desmaio',
    20: 'Rosto afogueado',
    21: 'Suor (não devido ao calor)',
  };

  static String prepSQLStringInsertInitialValuesAnsiedade =
      questionarioAnsiedadeQuestoesValues.entries.fold(
          'INSERT INTO $tableName (id_questao_questionario_domain, id_questionario_domain, ordem_questao, dsc_questao) VALUES ',
          (previousValue, element) =>
              previousValue +
              '(${QuestionarioDomain.ansiedadeBAIDomainValue + element.key}, ${QuestionarioDomain.ansiedadeBAIDomainValue}, ${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValuesAnsiedade =
      prepSQLStringInsertInitialValuesAnsiedade.substring(
              0, prepSQLStringInsertInitialValuesAnsiedade.length - 2) +
          ';';

  static String findQuestaoDescription(
      int questionarioDomainId, int questaoOrdem) {
    switch (questionarioDomainId) {
      case QuestionarioDomain.ansiedadeBAIDomainValue:
        return questionarioAnsiedadeQuestoesValues[questaoOrdem]!;
      default:
        return 'Questionário informado inválido';
    }
    ;
  }
}
