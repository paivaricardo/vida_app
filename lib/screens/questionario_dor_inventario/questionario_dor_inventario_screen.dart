import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/add_drug_widget.dart';
import 'package:vida_app/components/dor_inventario_body_part_selector.dart';
import 'package:vida_app/components/slider_questionario_dor_inventario.dart';
import 'package:vida_app/components/slider_questionario_dor_inventario_percentage.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_dor_inventario_model.dart';
import 'package:vida_app/screens/questionario_dor_inventario/questionario_dor_inventario_resultado_screen.dart';

class QuestionarioDorInventarioScreen extends StatefulWidget {
  final Paciente paciente;

  const QuestionarioDorInventarioScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  QuestionarioDorInventarioScreenState createState() =>
      QuestionarioDorInventarioScreenState();
}

class QuestionarioDorInventarioScreenState
    extends State<QuestionarioDorInventarioScreen> {
  // Uuid
  String generatedUuid = Uuid().v4();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _observacoesQuestionarioDorInventario =
      TextEditingController();

  // Questionário de depressão PHQ-9 - objeto onde os dados serão salvos
  late QuestionarioDorInventario questionarioDorInventario =
      QuestionarioDorInventario.buildFromPaciente(paciente: widget.paciente);

  // Number of drugs added
  List<Widget> addDrugsWidgetsList = [];

  @override
  Widget build(BuildContext context) {
    double modulo = (MediaQuery.of(context).size.width * 0.9) / 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de dor - Inventário Breve da Dor'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'INVENTÁRIO BREVE DA DOR',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Paciente:',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.paciente.nome,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Observações'),
                        controller: _observacoesQuestionarioDorInventario,
                        maxLength: 500,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      Text(QuestaoQuestionarioDomain
                          .questionarioDorInventarioQuestoesValues[1]!),
                      ListTile(
                        title: Text('Sim'),
                        leading: Radio<int>(
                          groupValue:
                              questionarioDorInventario.questoes[1]!.pontuacao,
                          value: 1,
                          onChanged: (value) {
                            setState(() {
                              questionarioDorInventario.questoes[1]!.pontuacao =
                                  value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('Não'),
                        leading: Radio<int>(
                          groupValue:
                              questionarioDorInventario.questoes[1]!.pontuacao,
                          value: 0,
                          onChanged: (value) {
                            setState(() {
                              questionarioDorInventario.questoes[1]!.pontuacao =
                                  value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[2]!),
                      ),
                      Container(
                        width: modulo * 4,
                        height: modulo * 4 * 2.34,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                              'assets/images/inventario_dor_body_front.png'),
                          fit: BoxFit.cover,
                        )),
                        child: Stack(
                          children: _returnListButtonsBodyParts(modulo: modulo, side: 'front'),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.9 * 2.34,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                              'assets/images/inventario_dor_body_back.png'),
                          fit: BoxFit.cover,
                        )),
                        child: Stack(
                          children: _returnListButtonsBodyParts(modulo: modulo, side: 'back'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[3]!),
                      ),
                      SliderQuestionarioDorInventario(
                          questao: questionarioDorInventario.questoes[3]!),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[4]!),
                      ),
                      SliderQuestionarioDorInventario(
                          questao: questionarioDorInventario.questoes[4]!),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[5]!),
                      ),
                      SliderQuestionarioDorInventario(
                          questao: questionarioDorInventario.questoes[5]!),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[6]!),
                      ),
                      SliderQuestionarioDorInventario(
                          questao: questionarioDorInventario.questoes[6]!),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[7]!),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (addDrugsWidgetsList.length < 9) {
                                addDrugsWidgetsList.add(AddDrugWidget());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Número máximo de medicamentos atingido.')));
                              }
                            });
                          },
                          icon: Icon(Icons.medical_services_rounded),
                          label: Text('Acrescentar medicamento')),
                      ...addDrugsWidgetsList,
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[8]!),
                      ),
                      SliderQuestionarioDorInventarioPercentage(
                          questao: questionarioDorInventario.questoes[8]!),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[9]!),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[10]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[10]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[11]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[11]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[12]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[12]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[13]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[13]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[14]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[14]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[15]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[15]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(QuestaoQuestionarioDomain
                            .questionarioDorInventarioQuestoesValues[16]!),
                      ),
                      SliderQuestionarioDorInventario(
                        questao: questionarioDorInventario.questoes[16]!,
                        beginLabel: 'Não interferiu',
                        endLabel: 'Interferiu completamente',
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      label: Text('CANCELAR'),
                      icon: Icon(Icons.cancel),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            // Registros no questionário geral
                            questionarioDorInventario.uuidQuestionarioAplicado =
                                generatedUuid;

                            questionarioDorInventario.dataRealizacao =
                                DateTime.now();

                            // Não há registro de pontuação neste questionário

                            // Registro das observações:
                            questionarioDorInventario.observacoes =
                                _observacoesQuestionarioDorInventario.text.isEmpty ? 'SEM OBSERVAÇÕES' : _observacoesQuestionarioDorInventario.text;

                            // Registrar o pesquisador responsável
                            questionarioDorInventario.pesquisadorResponsavel =
                                Provider.of<Pesquisador?>(context,
                                    listen: false);

                            // Montagem do array de maps medicamentos
                            questionarioDorInventario.medicineList =
                                List<Map<String, dynamic>>.from(
                                    addDrugsWidgetsList.map((medicine) {
                              AddDrugWidget drugWidget =
                                  medicine as AddDrugWidget;

                              Map<String, dynamic> returnedMap = {
                                'nomeMedicamento':
                                    drugWidget.controllerNomeMedicamento.text,
                                'doseMedicamento':
                                    drugWidget.controllerDoseMedicamento.text,
                                'dataInicioMedicamento':
                                    DateTimeHelper.dateParse(drugWidget
                                        .controllerDataMedicamento.text),
                              };

                              return returnedMap;
                            }));

                            // Salvar o questionário e todos os seus registros no banco de dados Firestore Database
                            questionarioDorInventario.firestoreAdd();

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultadoQuestionarioDorInventarioScreen(
                                      questionario: questionarioDorInventario,
                                    )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Alguns dados estão inválidos. Verifique os dados e tente submeter novamente.')));
                          }
                        } catch (error, stacktrace) {
                          print(error);
                          print(stacktrace.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Houve um erro ao tentar salvar o questionário.')));
                        }
                      },
                      label: Text('GRAVAR'),
                      icon: Icon(Icons.save),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _returnListButtonsBodyParts({required side, required modulo}) {
    List<Widget> returnedWidgets = <Widget>[];

    switch(side) {
      case 'front':
        for(int index in QuestionarioDorInventario.frontBodyPartsIndexes) {
          returnedWidgets.add(DorInventarioBodyPartSelector(
            bodyPartNumber: index,
            modulo: modulo,
            questionarioDorInventario: questionarioDorInventario,
          ));
        }
        return returnedWidgets;
      case 'back':
        for(int index in QuestionarioDorInventario.backBodyPartsIndexes) {
          returnedWidgets.add(DorInventarioBodyPartSelector(
            bodyPartNumber: index,
            modulo: modulo,
            questionarioDorInventario: questionarioDorInventario,
          ));
        }
        return returnedWidgets;
      default:
        return returnedWidgets;
    }
  }
}
