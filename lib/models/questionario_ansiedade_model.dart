import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';

class QuestionarioAnsiedade extends Questionario {
  static int idQuestionarioAnsiedadeDomain = QuestionarioDomain.ansiedadeBAIDomainValue;

  static String tableName = 'questionario_ansiedade';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_questionario_aplicado`    text NOT NULL ,
       `possui_diagnostico_ansiedade`  text NOT NULL ,
       `desde_quando_possui_diag`      text NULL ,
       `ja_encontra_tratamento`        text NULL ,
       `tempo_tratamento`              text NULL ,
       `tratamento_atual_ansiedade`    text NULL ,
       `tratamentos_previos_ansiedade` text NULL ,
      
      PRIMARY KEY (`uuid_questionario_aplicado`),
      FOREIGN KEY (`uuid_questionario_aplicado`) REFERENCES `questionario_aplicado` (`uuid_questionario_aplicado`)
      );
  ''';

  String? interpretacaoScoreBAI;

  // Questionário específico - subclasse
  String possuiDiagnosticoAnsiedade = 'N';
  DateTime? desdeQuandoPossuiDiag;
  bool jaEncontraTratamento = false;
  String tempoTratamento = 'Sem tempo definido';
  String tratamentoAtualAnsiedade = 'Nenhum';
  String tratamentosPreviosAnsiedade = 'Nenhum';

  QuestionarioAnsiedade({paciente}) : super(idQuestionarioDomain: idQuestionarioAnsiedadeDomain, paciente: paciente);

  late Map<int, Questao> questoes = Map<int, Questao>.fromIterable(
      List.generate(QuestaoQuestionarioDomain.questionarioAnsiedadeQuestoesValues.length, (index) => index + 1),
      key: (item) => int.parse(item.toString()),
      value: (item) => Questao(this, int.parse(item.toString())));

  void registrarInterpretacaoScoreBAI(int pontuacaoTotal) {
    if (pontuacaoTotal <= 7) {
      interpretacaoScoreBAI = 'Grau mínimo de ansiedade';
    } else if (pontuacaoTotal <= 15) {
      interpretacaoScoreBAI = 'Ansiedade leve';
    } else if (pontuacaoTotal <= 25) {
      interpretacaoScoreBAI = 'Ansiedade moderada';
    } else {
      interpretacaoScoreBAI = 'Ansiedade grave';
    }
  }

  @override
  String toString() {
    return 'QuestionarioAnsiedade{interpretacaoScoreBAI: $interpretacaoScoreBAI, possuiDiagnosticoAnsiedade: $possuiDiagnosticoAnsiedade, desdeQuandoPossuiDiag: $desdeQuandoPossuiDiag, jaEncontraTratamento: $jaEncontraTratamento, tempoTratamento: $tempoTratamento, tratamentoAtualAnsiedade: $tratamentoAtualAnsiedade, tratamentosPreviosAnsiedade: $tratamentosPreviosAnsiedade, questoes: $questoes}';
  }
}
