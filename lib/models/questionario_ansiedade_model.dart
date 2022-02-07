import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/screens/questionario_ansiedade/resultado_questionario_ansiedade_screen.dart';

class QuestionarioAnsiedade extends Questionario {
  static int idQuestionarioAnsiedadeDomain =
      QuestionarioDomain.ansiedadeBAIDomainValue;

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

  // Questões
  Map<int, Questao> questoes;

  // Questionário específico - subclasse
  String possuiDiagnosticoAnsiedade = 'N';
  DateTime? desdeQuandoPossuiDiag;
  bool jaEncontraTratamento = false;
  String tempoTratamento = 'Sem tempo definido';
  String tratamentoAtualAnsiedade = 'Nenhum';
  String tratamentosPreviosAnsiedade = 'Nenhum';

  QuestionarioAnsiedade({
    uuidQuestionarioAplicado,
    dataRealizacao,
    idQuestionarioDomain,
    paciente,
    pontuacaoQuestionario,
    interpretacaoPontuacaoQuestionario,
    pesquisadorResponsavel,
    observacoes,
    icActive,
    required this.questoes,
    this.possuiDiagnosticoAnsiedade = 'N',
    this.desdeQuandoPossuiDiag,
    this.jaEncontraTratamento = false,
    this.tempoTratamento = 'Sem tempo definido',
    this.tratamentoAtualAnsiedade = 'Nenhum',
    this.tratamentosPreviosAnsiedade = 'Nenhum',
  }) : super(
          uuidQuestionarioAplicado: uuidQuestionarioAplicado,
          dataRealizacao: dataRealizacao,
          idQuestionarioDomain: idQuestionarioDomain,
          paciente: paciente,
          pontuacaoQuestionario: pontuacaoQuestionario,
          interpretacaoPontuacaoQuestionario:
              interpretacaoPontuacaoQuestionario,
          pesquisadorResponsavel: pesquisadorResponsavel,
          observacoes: observacoes,
          icActive: icActive,
        );

  QuestionarioAnsiedade.buildFromPaciente({paciente})
      : questoes = initializeQuestoes(),
        super.buildMinimal(
            idQuestionarioDomain: idQuestionarioAnsiedadeDomain,
            paciente: paciente);

  QuestionarioAnsiedade.buildFromQuestionario(Questionario questionario)
      : questoes = initializeQuestoes(),
        super.buildFromQuestionario(questionario);

  static Map<int, Questao> initializeQuestoes() {
    return Map<int, Questao>.fromIterable(
        List.generate(
            QuestaoQuestionarioDomain
                .questionarioAnsiedadeQuestoesValues.length,
            (index) => index + 1),
        key: (item) => int.parse(item.toString()),
        value: (item) =>
            Questao(idQuestionarioAnsiedadeDomain, int.parse(item.toString())));
  }

  static String gerarInterpretacaoScoreBAI(int pontuacaoTotal) {
    if (pontuacaoTotal <= 7) {
      return 'Grau mínimo de ansiedade';
    } else if (pontuacaoTotal <= 15) {
      return 'Ansiedade leve';
    } else if (pontuacaoTotal <= 25) {
      return 'Ansiedade moderada';
    } else {
      return 'Ansiedade grave';
    }
  }

  void registrarInterpretacaoScoreBAI(int pontuacaoTotal) {
    interpretacaoPontuacaoQuestionario =
        gerarInterpretacaoScoreBAI(pontuacaoTotal);
  }

  @override
  QuestionarioAnsiedade.fromJson(Map<String, dynamic> json)
      : this(
          uuidQuestionarioAplicado: json['uuidQuestionarioAplicado'],
          dataRealizacao: json['dataRealizacao'].toDate(),
          idQuestionarioDomain: json['idQuestionarioDomain'],
          paciente: Paciente.fromJson(json['paciente']),
          pontuacaoQuestionario: json['pontuacaoQuestionario'],
          interpretacaoPontuacaoQuestionario:
              json['interpretacaoPontuacaoQuestionario'],
          pesquisadorResponsavel:
              Pesquisador.fromJson(json['pesquisadorResponsavel']),
          observacoes: json['observacoes'],
          icActive: json['icActive'],
          questoes: Map<int, Questao>.fromIterable(
            json['questoes'].entries,
            key: (entry) => int.parse(entry.key),
            value: (entry) => Questao(
                json['idQuestionarioDomain'], int.parse(entry.key),
                pontuacao: entry.value),
          ),
          possuiDiagnosticoAnsiedade: json['possuiDiagnosticoAnsiedade'],
          desdeQuandoPossuiDiag: json['desdeQuandoPossuiDiag'] == null
              ? null
              : json['desdeQuandoPossuiDiag'].toDate(),
          jaEncontraTratamento: json['jaEncontraTratamento'],
          tempoTratamento: json['tempoTratamento'],
          tratamentoAtualAnsiedade: json['tratamentoAtualAnsiedade'],
          tratamentosPreviosAnsiedade: json['tratamentosPreviosAnsiedade'],
        );

  // @override
  Map<String, dynamic> toJson() {
    return {
      'uuidQuestionarioAplicado': uuidQuestionarioAplicado,
      'dataRealizacao': dataRealizacao,
      'idQuestionarioDomain': idQuestionarioDomain,
      'paciente': paciente.toJson(),
      'pontuacaoQuestionario': pontuacaoQuestionario,
      'interpretacaoPontuacaoQuestionario': interpretacaoPontuacaoQuestionario,
      'pesquisadorResponsavel': pesquisadorResponsavel!.toJson(),
      'observacoes': observacoes,
      'icActive': icActive,
      'questoes': Map<String, dynamic>.fromIterable(questoes.entries,
          key: (entry) => entry.value.ordemQuestaoDomain.toString(),
          value: (entry) => entry.value.pontuacao),
      'possuiDiagnosticoAnsiedade': possuiDiagnosticoAnsiedade,
      'desdeQuandoPossuiDiag': desdeQuandoPossuiDiag,
      'jaEncontraTratamento': jaEncontraTratamento,
      'tempoTratamento': tempoTratamento,
      'tratamentoAtualAnsiedade': tratamentoAtualAnsiedade,
      'tratamentosPreviosAnsiedade': tratamentosPreviosAnsiedade,
    };
  }

  Future<void> firestoreAdd() {
    CollectionReference questionarios = FirebaseFirestore.instance
        .collection(Questionario.firestoreCollectionName);

    return questionarios.doc(uuidQuestionarioAplicado).set(toJson());
  }

  Widget buildSnippet(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultadoQuestionarioAnsiedadeScreen(
                        questionario: this)));
          },
          child: SizedBox(
            height: 130,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.list_alt_rounded),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Questionário',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        QuestionarioDomain.retriveNomeQuestionario(
                            idQuestionarioDomain)[0],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        QuestionarioDomain.retriveNomeQuestionario(
                            idQuestionarioDomain)[1],
                        style: TextStyle(color: Colors.grey),
                      ),
                      Visibility(
                          visible: QuestionarioDomain
                              .visibleScores[idQuestionarioDomain]!,
                          child: Text(
                            'Score: ${pontuacaoQuestionario} (${interpretacaoPontuacaoQuestionario})',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.deepOrange),
                          )),
                      Text(
                          'Data: ${DateTimeHelper.retrieveFormattedDateStringBR(dataRealizacao)}'),
                      Text('Id.: $uuidQuestionarioAplicado'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
