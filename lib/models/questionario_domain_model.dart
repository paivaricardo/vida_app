class QuestionarioDomain {
  static String tableName = 'questionario_domain';

  // Domain values
  static const ansiedadeBAIDomainValue = 1000;
  static const depressaoPHQ9DomainValue = 2000;
  static const depressaoBeckDomainValue = 3000;
  static const dorInventarioDomainValue = 4000;
  static const dorStartDomainValue = 5000;
  static const tabagismoFargestromDomainValue = 6000;

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `id_questionario_domain` integer NOT NULL ,
       `nome_questionario`      text NOT NULL ,
       `tipo_questionario`      text NOT NULL ,
      
      PRIMARY KEY (`id_questionario_domain`)
      );
  ''';

  static Map<int, List<String>> questionarioDomainValues = {
    ansiedadeBAIDomainValue: ['Ansiedade', 'BAI (INVENTÁRIO DE ANSIEDADE DE BECK)'],
    depressaoPHQ9DomainValue: ['Depressão', 'Patient Health Questionnaire-9 (PHQ-9).'],
    depressaoBeckDomainValue: ['Depressão', 'ESCALA DE DEPRESSÃO DE BECK.'],
    dorInventarioDomainValue: ['Dor', 'INVENTÁRIO BREVE DA DOR.'],
    dorStartDomainValue: ['Dor', 'STarT Back Screening Tool- Brasil (SBST-Brasil).'],
    tabagismoFargestromDomainValue: ['Tabagismo', 'TESTE DE FARGESTRÖM.'],
  };

  static Map<int, bool> visibleScores = {
    ansiedadeBAIDomainValue: true,
    depressaoPHQ9DomainValue: true,
    depressaoBeckDomainValue: true,
    dorInventarioDomainValue: false,
    dorStartDomainValue: true,
    tabagismoFargestromDomainValue: true,
  };

  static String prepSQLStringInsertInitialValues = questionarioDomainValues.entries.fold(
      'INSERT INTO $tableName (id_questionario_domain, tipo_questionario, nome_questionario) VALUES ',
          (previousValue, element) =>
      previousValue + '(${element.key}, \'${element.value[0]}\', \'${element.value[1]}\'), ');

  static String SQLStringInsertInitialValues = prepSQLStringInsertInitialValues
      .substring(0, prepSQLStringInsertInitialValues.length - 2) +
      ';';

  // static int getQuestionarioDomainId(String questionarioValue) {
  //   return questionarioValues.entries
  //       .firstWhere((element) => element.value == questionarioValue)
  //       .key;
  // }
  //
  // static String getQuestionarioDomainValue(int questionarioId) {
  //   return questionarioValues[questionarioId]!;
  // }

  static List<String> retriveNomeQuestionario(int idQuestionarioDomain) {
    return questionarioDomainValues[idQuestionarioDomain] ?? ['Não encontrado', 'Não encontrado'];
  }

}