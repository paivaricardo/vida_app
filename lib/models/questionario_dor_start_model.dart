import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/screens/questionario_depressao_phq9/questionario_depressao_phq9_resultado_screen.dart';
import 'package:vida_app/screens/questionario_dor_start/questionario_dor_start_resultado_screen.dart';

class QuestionarioDorStart extends Questionario {
  static int idQuestionarioDorStartDomain =
      QuestionarioDomain.dorStartDomainValue;

  static const String firestoreCollectionName =
      Questionario.firestoreCollectionName;

  // Questões
  Map<int, Questao> questoes;

  // Campos específicos do questionário STarT Back Screening Tool- Brasil (SBST-Brasil).
  int pontuacaoSubescalaPsicossocial;
  String classificaoQuestao9Incomodo;

  QuestionarioDorStart({
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
    required this.pontuacaoSubescalaPsicossocial,
    required this.classificaoQuestao9Incomodo,
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

  QuestionarioDorStart.buildFromPaciente({paciente})
      : questoes = initializeQuestoes(),
      pontuacaoSubescalaPsicossocial = 0,
        classificaoQuestao9Incomodo = QuestaoQuestionarioDomain.questionarioDorStartAnswers9[0]![0],
        super.buildMinimal(
            idQuestionarioDomain: idQuestionarioDorStartDomain,
            paciente: paciente);

  QuestionarioDorStart.buildFromQuestionario(Questionario questionario)
      : questoes = initializeQuestoes(),
        pontuacaoSubescalaPsicossocial = 0,
        classificaoQuestao9Incomodo = QuestaoQuestionarioDomain.questionarioDorStartAnswers9[0]![0],
        super.buildFromQuestionario(questionario);

  static Map<int, Questao> initializeQuestoes() {
    return Map<int, Questao>.fromIterable(
        List.generate(
            QuestaoQuestionarioDomain
                .questionarioDorStartQuestoesValues.length,
            (index) => index + 1),
        key: (item) => int.parse(item.toString()),
        value: (item) => Questao(
            idQuestionarioDorStartDomain, int.parse(item.toString())));
  }

  @override
  QuestionarioDorStart.fromJson(Map<String, dynamic> json)
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
        pontuacaoSubescalaPsicossocial: json['pontuacaoSubescalaPsicossocial'],
        classificaoQuestao9Incomodo: json['classificaoQuestao9Incomodo'],

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
      'pontuacaoSubescalaPsicossocial' : pontuacaoSubescalaPsicossocial,
      'classificaoQuestao9Incomodo' : classificaoQuestao9Incomodo,
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
                    builder: (context) =>
                        ResultadoQuestionarioDorStartScreen(
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
                            'Score: ${pontuacaoQuestionario}',
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
