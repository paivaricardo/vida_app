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

  static Map<int, String> questionarioDepressaoPHQ9QuestoesValues = {
    1: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) teve pouco interesse ou pouco prazer em fazer as coisas?',
    2: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) se sentiu para baixo, deprimido(a) ou sem perspectiva?',
    3: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) teve dificuldade para pegar no sono ou permanecer dormindo ou dormiu mais do que de costume?',
    4: 'Nas últimas duas semanas, quantos dias o(a) sr.(a ) se sentiu cansado(a) ou com pouca energia?',
    5: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) teve falta de apetite ou comeu demais?',
    6: 'Nas últimas duas semanas, quantos dias o(a) sr.(a ) se sentiu mal consigo mesmo(a) ou achou que é um fracasso ou que decepcionou sua família ou a você mesmo(a)?',
    7: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) teve dificuldade para se concentrar nas coisas (como ler o jornal ou ver televisão)?',
    8: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) teve lentidão para se movimentar ou falar (a ponto das outras pessoas perceberem), ou ao contrário, esteve tão agitado(a) que você ficava andando de um lado para o outro mais do que de costume?',
    9: 'Nas últimas duas semanas, quantos dias o(a) sr.(a) pensou em se ferir de alguma maneira ou que seria melhor estar morto(a)?',
    10: 'Considerando as últimas duas semanas, os sintomas anteriores lhe causaram algum tipo de dificuldade para trabalhar ou estudar ou tomar conta das coisas em casa ou para se relacionar com as pessoas?',
  };

  static Map<int, String> questionarioDepressaoPHQ9Answers1to9 = {
    0: 'Nenhum dia',
    1: 'Menos de uma semana',
    2: 'Uma semana ou mais',
    3: 'Quase todos os dias',
  };

  static Map<int, String> questionarioDepressaoPHQ9Answer10 = {
    0: 'Nenhuma dificuldade',
    1: 'Pouca dificuldade',
    2: 'Muita dificuldade',
    3: 'Extrema dificuldade',
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

  static String prepSQLStringInsertInitialValuesDepressaoPHQ9 =
      questionarioDepressaoPHQ9QuestoesValues.entries.fold(
          'INSERT INTO $tableName (id_questao_questionario_domain, id_questionario_domain, ordem_questao, dsc_questao) VALUES ',
          (previousValue, element) =>
              previousValue +
              '(${QuestionarioDomain.depressaoPHQ9DomainValue + element.key}, ${QuestionarioDomain.depressaoPHQ9DomainValue}, ${element.key}, \'${element.value}\'), ');

  static String SQLStringInsertInitialValuesDepressaoPHQ9 =
      prepSQLStringInsertInitialValuesDepressaoPHQ9.substring(
              0, prepSQLStringInsertInitialValuesDepressaoPHQ9.length - 2) +
          ';';

  static String findQuestaoDescription(
      int questionarioDomainId, int questaoOrdem) {
    switch (questionarioDomainId) {
      case QuestionarioDomain.ansiedadeBAIDomainValue:
        return questionarioAnsiedadeQuestoesValues[questaoOrdem]!;
      case QuestionarioDomain.depressaoPHQ9DomainValue:
        return questionarioDepressaoPHQ9QuestoesValues[questaoOrdem]!;
      default:
        return 'Questionário informado inválido';
    }
    ;
  }
}
