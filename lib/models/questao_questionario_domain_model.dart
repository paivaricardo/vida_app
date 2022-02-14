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
    10: 'Considerando as últimas duas semanas, os sintomas anteriores lhe causaram algum tipo de dificuldade para trabalhar ou estudar ou tomar conta_screens das coisas em casa ou para se relacionar com as pessoas?',
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

  static Map<int, Map<int, String>> questionarioDepressaoBeckQuestoesValues = {
    1: {0: 'não me sinto triste', 1: 'sinto-me triste', 2: 'sinto-me triste o tempo todo e não consigo sair disto', 3: 'estou tão triste e infeliz que não posso aguentar'},
    2: {0: 'não estou particularmente desencorajado(a) frente ao futuro', 1: 'sinto-me desencorajado(a) frente ao futuro', 2: 'sinto que não tenho nada por que esperar', 3: 'sinto que o futuro é sem esperança e que as coisas não vão melhorar'},
    3: {0: 'não me sinto fracassado(a)', 1: 'sinto que falhei mais do que um indivíduo médio', 2: 'quando olho para trás em minha vida, só vejo uma porção de fracassos', 3: 'sinto que sou um fracasso completo como pessoa'},
    4: {0: 'não obtenho tanta satisfação com as coisas como costumava fazer', 1: 'não gosto das coisas da maneira como costumava gostar', 2: 'não consigo mais sentir satisfação real com coisa alguma', 3: 'estou insatisfeito(a) ou entediado(a) com tudo'},
    5: {0: 'não me sinto particularmente culpado(a)', 1: 'sinto-me culpado(a) boa parte do tempo', 2: 'sinto-me muito culpado(a) a maior parte do tempo', 3: 'sinto-me culpado(a) o tempo todo'},
    6: {0: 'não sinto que esteja sendo punido(a)', 1: 'sinto que posso ser punido(a)', 2: 'espero ser punido(a)', 3: 'sinto que estou sendo punido(a)'},
    7: {0: 'não me sinto desapontado(a) comigo mesmo(a)', 1: 'sinto-me desapontado(a) comigo mesmo(a)', 2: 'sinto-me aborrecido(a) comigo mesmo(a)', 3: 'eu me odeio'},
    8: {0: 'não sinto que seja pior que qualquer pessoa', 1: 'critico minhas fraquezas ou erros', 2: 'responsabilizo-me o tempo todo por minhas falhas', 3: 'culpo-me por todas as coisas ruins que acontecem'},
    9: {0: 'não tenho nenhum pensamento a respeito de me matar', 1: 'tenho pensamentos a respeito de me matar mas não os levaria adiante', 2: 'gostaria de me matar', 3: 'eu me mataria se tivesse uma oportunidade'},
    10: {0: 'não costumo chorar mais do que o habitual', 1: 'choro mais agora do que costumava chorar antes', 2: 'atualmente choro o tempo todo', 3: 'eu costumava chorar, mas agora não consigo mesmo que queira'},
    11: {0: 'não me irrito mais agora do que em qualquer outra época', 1: 'fico molestado(a) ou irritado(a) mais facilmente do que costumava', 2: 'atualmente sinto-me irritado(a) o tempo todo', 3: 'absolutamente não me irrito com as coisas que costumam irritar-me'},
    12: {0: 'não perdi o interesse nas outras pessoas', 1: 'interesso-me menos do que costumava pelas outras pessoas', 2: 'perdi a maior parte do meu interesse pelas outras pessoas', 3: 'perdi todo o meu interesse nas outras pessoas'},
    13: {0: 'tomo as decisões quase tão bem como em qualquer outra época', 1: 'adio minhas decisões mais do que costumava', 2: 'tenho maior dificuldade em tomar decisões do que antes ', 3: 'não consigo mais tomar decisões'},
    14: {0: 'não sinto que minha aparência seja pior do que costumava ser', 1: 'preocupo-me por estar parecendo velho(a) ou sem atrativos', 2: 'sinto que há mudanças em minha aparência que me fazem parecer sem atrativos', 3: 'considero-me feio(a)'},
    15: {0: 'posso trabalhar mais ou menos tão bem quanto antes', 1: 'preciso de um esforço extra para começar qualquer coisa', 2: 'tenho que me esforçar muito até fazer qualquer coisa', 3: 'não consigo fazer trabalho nenhum'},
    16: {0: 'durmo tão bem quanto de hábito ', 1: 'não durmo tão bem quanto costumava', 2: 'acordo 1 ou 2 horas mais cedo do que de hábito e tenho dificuldade de voltar a dormir', 3: 'acordo várias horas mais cedo do que costumava e tenho dificuldade de voltar a dormir'},
    17: {0: 'não fico mais cansado(a) do que de hábito', 1: 'fico cansado(a) com mais facilidade do que costumava', 2: 'sinto-me cansado(a) ao fazer qualquer coisa', 3: 'estou cansado(a) demais para fazer qualquer coisa'},
    18: {0: 'o meu apetite não está pior do que de hábito', 1: 'meu apetite não é tão bom como costumava ser', 2: 'meu apetite está muito pior agora', 3: 'não tenho mais nenhum apetite'},
    19: {0: 'não perdi muito peso se é que perdi algum ultimamente', 1: 'perdi mais de 2,5 kg estou deliberadamente', 2: 'perdi mais de 5,0 kg tentando perder peso', 3: 'perdi mais de 7,0 kg comendo menos'},
    20: {0: 'não me preocupo mais do que de hábito com minha saúde', 1: 'preocupo-me com problemas físicos como dores e aflições, ou perturbações no estômago, ou prisões de ventre', 2: 'estou preocupado(a) com problemas físicos e é difícil pensar em muito mais do que isso', 3: 'estou tão preocupado(a) em ter problemas físicos que não consigo pensar em outra coisa'},
    21: {0: 'não tenho observado qualquer mudança recente em meu interesse sexual', 1: 'estou menos interessado(a) por sexo do que costumava', 2: 'estou bem menos interessado(a) por sexo atualmente', 3: 'perdi completamente o interesse por sexo'},
  };

  static Map<int, String> questionarioDorInventarioQuestoesValues = {
    1: '1) Durante a vida, a maioria das pessoas apresenta dor de vez em quando (dor de cabeça, dor de dente, etc.). Você teve, hoje, dor diferente dessas?',
    2: '2) Marque, sobre o diagrama, as áreas onde você sente dor, e onde a dor é mais intensa.',
    3: '3) Selecione o número que melhor descreve a pior dor que você sentiu nas últimas 24 horas.',
    4: '4) Selecione o número que melhor descreve a dor mais fraca que você sentiu nas últimas 24 horas.',
    5: '5) Selecione o número que melhor descreve a média da sua dor.',
    6: '6) Selecione o número que mostra quanta dor você está sentindo agora (neste momento).',
    7: '7) Quais tratamentos ou medicações você está recebendo para dor?',
    8: '8) Nas últimas 24 horas, qual a intensidade da melhora proporcionada pelos tratamentos ou medicações que você está usando? Selecione o  percentual de alívio que você obteve.',
    9: '9) Selecione o número que melhor descreve como, nas últimas 24 horas, a dor interferiu na sua:',
    10: 'Atividade geral',
    11: 'Humor',
    12: 'Habilidade de caminhar',
    13: 'Trabalho',
    14: 'Relacionamento com outras pessoas',
    15: 'Sono',
    16: 'Habilidade para apreciar a vida',
  };

  static Map<int, String> questionarioDorStartQuestoesValues = {
    1: 'A  minha dor nas costas se espalhou pelas pernas nas duas últimas semanas.',
    2: 'Eu tive dor no ombro e/ou na nuca pelo menos uma vez nas últimas duas semanas.',
    3: 'Eu evito andar longas distâncias por causa da minha dor nas costas.',
    4: 'Nas duas últimas semanas, tenho me vestido mais devagar por causa da minha dor nas costas.',
    5: 'A  atividade física não é realmente segura para uma pessoa com um problema como o meu.',
    6: 'Tenho ficado preocupado por muito tempo por causa da minha dor nas costas.',
    7: 'Eu sinto que minha dor nas costas é terrível e que nunca vai melhorar.',
    8: 'Em geral, eu não tenho gostado de todas as coisas como eu costumava gostar.',
    9: 'Em geral, quanto a sua dor nas costas o incomodou nas duas últimas semanas:',
  };

  static Map<int, String> questionarioDorStartAnswers1to8 = {
    0: 'Discordo (0)',
    1: 'Concordo (1)',
  };

  static Map<int, List<String>> questionarioDorStartAnswers9 = {
    0: ['Nada (0)', 'Pouco (0)', 'Moderado (0)'],
    1: ['Muito (1)', 'Extremamente (1)'],
  };

  static Map<int, String> questionarioTabagismoFagerstromQuestoesValues = {
    1: 'Quanto tempo  depois de acordar você fuma o  primeiro cigarro?',
    2: 'Você encontra  dificuldades  em  evitar  de  fumar em  locais  proibidos, como por  exemplo: igrejas,  local de  trabalho,  cinemas,  shoppings,  etc?',
    3: 'Qual  o cigarro mais  difícil de largar  de fumar?',
    4: 'Quantos cigarros você  fuma por dia?',
    5: 'Você  fuma mais freqüentemente  nas primeiras horas do dia do que durante o resto  do dia?',
    6: 'Você fuma mesmo estando doente ao ponto de  ficar acamado  na maior parte do  dia?',
  };

  static Map<int, Map<int, String>> questionarioTabagismoFagerstromQuestoesChoices = {
    1: {0: 'após 60 minutos', 1: 'entre 31  e 60  minutos', 2: 'entre seis  e 30  mintuos', 3: 'nos primeiros cinco minutos'},
    2: {0: 'não', 1: 'sim'},
    3: {0: 'qualquer  outro', 1: 'o primeiro  da manhã'},
    4: {0: 'menos de 10  cigarros', 1: 'entre  11  e 20  cigarros', 2: 'entre  21  e 30  cigarros', 3: 'mais de 30  cigarros'},
    5: {0: 'não', 1: 'sim'},
    6: {0: 'não', 1: 'sim'},
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
      case QuestionarioDomain.depressaoBeckDomainValue:
        return questionarioDepressaoBeckQuestoesValues[questaoOrdem]![0]!;
      case QuestionarioDomain.dorInventarioDomainValue:
        return questionarioDorInventarioQuestoesValues[questaoOrdem]!;
      case QuestionarioDomain.dorStartDomainValue:
        return questionarioDorStartQuestoesValues[questaoOrdem]!;
      case QuestionarioDomain.tabagismoFagerstromDomainValue:
        return questionarioTabagismoFagerstromQuestoesValues[questaoOrdem]!;
      default:
        return 'Questionário informado inválido';
    }
  }
}
