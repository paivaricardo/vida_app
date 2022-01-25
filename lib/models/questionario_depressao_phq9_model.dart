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

class QuestionarioDepressaoPHQ9 extends Questionario {
  static int idQuestionarioDepressaoPHQ9Domain =
      QuestionarioDomain.depressaoPHQ9DomainValue;

  static const String firestoreCollectionName =
      Questionario.firestoreCollectionName;

  // Questões
  Map<int, Questao> questoes;

  QuestionarioDepressaoPHQ9({
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

  QuestionarioDepressaoPHQ9.buildFromPaciente({paciente})
      : questoes = initializeQuestoes(),
        super.buildMinimal(
            idQuestionarioDomain: idQuestionarioDepressaoPHQ9Domain,
            paciente: paciente);

  QuestionarioDepressaoPHQ9.buildFromQuestionario(Questionario questionario)
      : questoes = initializeQuestoes(),
        super.buildFromQuestionario(questionario);

  // Map<int, Questao> questoes = Map<int, Questao>.fromIterable(
  //     List.generate(
  //         QuestaoQuestionarioDomain.questionarioDepressaoPHQ9QuestoesValues
  //             .length, (index) => index + 1),
  //     key: (item) => int.parse(item.toString()),
  //     value: (item) => Questao(idQuestionarioDepressaoPHQ9Domain, int.parse(item.toString())));

  static Map<int, Questao> initializeQuestoes() {
    return Map<int, Questao>.fromIterable(
        List.generate(
            QuestaoQuestionarioDomain
                .questionarioDepressaoPHQ9QuestoesValues.length,
            (index) => index + 1),
        key: (item) => int.parse(item.toString()),
        value: (item) => Questao(
            idQuestionarioDepressaoPHQ9Domain, int.parse(item.toString())));
  }

  // static String gerarInterpretacaoScore(int pontuacaoTotal) {
  //   if (pontuacaoTotal <= 7) {
  //     return 'Grau mínimo de ansiedade';
  //   } else if (pontuacaoTotal <= 15) {
  //     return 'Ansiedade leve';
  //   } else if (pontuacaoTotal <= 25) {
  //     return 'Ansiedade moderada';
  //   } else {
  //     return 'Ansiedade grave';
  //   }
  // }

  // void registrarInterpretacaoScore(int pontuacaoTotal) {
  //   interpretacaoPontuacaoQuestionario =
  //       gerarInterpretacaoScore(pontuacaoTotal);
  // }

  @override
  QuestionarioDepressaoPHQ9.fromJson(Map<String, dynamic> json)
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
                        ResultadoQuestionarioDepressaoPHQ9Screen(
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
