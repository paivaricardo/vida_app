import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/screens/questionario_dor_inventario/questionario_dor_inventario_resultado_screen.dart';

class QuestionarioDorInventario extends Questionario {
  static int idQuestionarioDorInventarioDomain =
      QuestionarioDomain.dorInventarioDomainValue;

  static const String firestoreCollectionName =
      Questionario.firestoreCollectionName;

  static List<int> frontBodyPartsIndexes = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    50,
    51
  ];

  static List<int> backBodyPartsIndexes = [
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    52,
    53
  ];

  // Body parts positions - modularized according to the image width
  static Map<int, Map<String, double>> modularizedBodyPartsPositions = {
    // Front
    1: {'top': 0.846, 'left': 1.812, 'size': 0.300},
    2: {'top': 2.507, 'left': 1.304, 'size': 0.300},
    3: {'top': 2.677, 'left': 1.863, 'size': 0.300},
    4: {'top': 2.541, 'left': 2.355, 'size': 0.300},
    5: {'top': 3.219, 'left': 0.965, 'size': 0.300},
    6: {'top': 3.405, 'left': 1.422, 'size': 0.300},
    7: {'top': 3.490, 'left': 1.846, 'size': 0.300},
    8: {'top': 3.372, 'left': 2.287, 'size': 0.300},
    9: {'top': 3.185, 'left': 2.660, 'size': 0.300},
    10: {'top': 3.999, 'left': 1.490, 'size': 0.300},
    11: {'top': 3.999, 'left': 2.185, 'size': 0.300},
    12: {'top': 4.321, 'left': 1.490, 'size': 0.300},
    13: {'top': 4.321, 'left': 2.185, 'size': 0.300},
    14: {'top': 4.711, 'left': 1.846, 'size': 0.300},
    15: {'top': 5.219, 'left': 1.388, 'size': 0.500},
    16: {'top': 5.219, 'left': 2.100, 'size': 0.500},
    34: {'top': 4.168, 'left': 0.761, 'size': 0.300},
    35: {'top': 4.151, 'left': 2.863, 'size': 0.300},
    36: {'top': 6.473, 'left': 1.473, 'size': 0.400},
    37: {'top': 6.490, 'left': 2.033, 'size': 0.400},
    38: {'top': 7.355, 'left': 1.575, 'size': 0.300},
    39: {'top': 7.372, 'left': 2.100, 'size': 0.300},
    40: {'top': 8.355, 'left': 1.694, 'size': 0.300},
    41: {'top': 8.422, 'left': 2.066, 'size': 0.300},
    50: {'top': 5.117, 'left': 0.355, 'size': 0.400},
    51: {'top': 5.033, 'left': 3.066, 'size': 0.400},

    //  Back
    17: {'top': 1.100, 'left': 1.768, 'size': 0.300},
    18: {'top': 1.846, 'left': 1.768, 'size': 0.300},
    19: {'top': 2.541, 'left': 1.225, 'size': 0.300},
    20: {'top': 2.626, 'left': 1.751, 'size': 0.300},
    21: {'top': 2.575, 'left': 2.276, 'size': 0.300},
    22: {'top': 3.219, 'left': 0.836, 'size': 0.300},
    23: {'top': 3.405, 'left': 1.276, 'size': 0.300},
    24: {'top': 3.473, 'left': 1.768, 'size': 0.300},
    25: {'top': 3.405, 'left': 2.208, 'size': 0.300},
    26: {'top': 3.202, 'left': 2.632, 'size': 0.300},
    27: {'top': 4.185, 'left': 1.293, 'size': 0.300},
    28: {'top': 4.151, 'left': 2.208, 'size': 0.300},
    29: {'top': 4.812, 'left': 1.242, 'size': 0.300},
    30: {'top': 4.524, 'left': 1.768, 'size': 0.300},
    31: {'top': 4.812, 'left': 2.259, 'size': 0.300},
    32: {'top': 5.490, 'left': 1.327, 'size': 0.500},
    33: {'top': 5.507, 'left': 2.039, 'size': 0.500},
    42: {'top': 4.185, 'left': 0.700, 'size': 0.300},
    43: {'top': 4.202, 'left': 2.819, 'size': 0.300},
    44: {'top': 6.541, 'left': 1.497, 'size': 0.300},
    45: {'top': 6.541, 'left': 2.056, 'size': 0.300},
    46: {'top': 7.304, 'left': 1.480, 'size': 0.400},
    47: {'top': 7.304, 'left': 2.090, 'size': 0.400},
    48: {'top': 8.524, 'left': 1.666, 'size': 0.300},
    49: {'top': 8.541, 'left': 1.954, 'size': 0.300},
    52: {'top': 5.117, 'left': 0.514, 'size': 0.300},
    53: {'top': 5.049, 'left': 3.039, 'size': 0.300},
  };

  // Questões
  Map<int, Questao> questoes;

  // Medicine list
  List<Map<String, dynamic>?> medicineList;

  // painMapBody
  Map<String, int> painMapBody;

  QuestionarioDorInventario({
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
    required this.painMapBody,
    required this.medicineList,
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

  QuestionarioDorInventario.buildFromPaciente({paciente})
      : questoes = initializeQuestoes(),
        painMapBody = initializePainMapBody(),
        medicineList = [],
        super.buildMinimal(
            idQuestionarioDomain: idQuestionarioDorInventarioDomain,
            paciente: paciente);

  QuestionarioDorInventario.buildFromQuestionario(Questionario questionario)
      : questoes = initializeQuestoes(),
        painMapBody = initializePainMapBody(),
        medicineList = [],
        super.buildFromQuestionario(questionario);

  static Map<int, Questao> initializeQuestoes() {
    return Map<int, Questao>.fromIterable(
        List.generate(
            QuestaoQuestionarioDomain
                .questionarioDorInventarioQuestoesValues.length,
            (index) => index + 1),
        key: (item) => int.parse(item.toString()),
        value: (item) => Questao(
            idQuestionarioDorInventarioDomain, int.parse(item.toString())));
  }

  static Map<String, int> initializePainMapBody() {
    return Map<String, int>.fromIterable(
        List.generate(53, (index) => index + 1),
        key: (item) => item.toString(),
        value: (item) => 0);
  }

  @override
  QuestionarioDorInventario.fromJson(Map<String, dynamic> json)
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
            painMapBody: Map<String, int>.fromIterable(
                json['painMapBody'].entries,
                key: (entry) => entry.key,
                value: (entry) => int.parse(entry.value.toString())),
            medicineList: List<Map<String, dynamic>>.from(
                json['medicineList'].map((medicine) {
              Map<String, dynamic> returnedMap = {
                'nomeMedicamento': medicine['nomeMedicamento'],
                'doseMedicamento': medicine['doseMedicamento'],
                'dataInicioMedicamento':
                    medicine['dataInicioMedicamento'].toDate(),
              };

              return returnedMap;
            })));

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
      'painMapBody': painMapBody,
      'medicineList': medicineList,
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
                        ResultadoQuestionarioDorInventarioScreen(
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
