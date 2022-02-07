import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/menu_escolha_pontuacao_ansiedade_widget.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_dor_start_model.dart';
import 'package:vida_app/screens/questionario_dor_start/questionario_dor_start_resultado_screen.dart';

class QuestionarioDorStartScreen extends StatefulWidget {
  final Paciente paciente;

  const QuestionarioDorStartScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _QuestionarioDorStartScreenState createState() =>
      _QuestionarioDorStartScreenState();
}

class _QuestionarioDorStartScreenState
    extends State<QuestionarioDorStartScreen> {
  // Uuid
  String generatedUuid = Uuid().v4();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _observacoesQuestionarioDorStart =
      TextEditingController();

  // Questionário de depressão PHQ-9 - objeto onde os dados serão salvos
  late QuestionarioDorStart questionarioDorStart =
  QuestionarioDorStart.buildFromPaciente(paciente: widget.paciente);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de dor - STarT Back Screening Tool- Brasil (SBST-Brasil)'),
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
                    'STarT Back Screening Tool- Brasil (SBST-Brasil)',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Pensando nas duas últimas semanas, assinale sua resposta para as seguintes perguntas:',
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
                        decoration: InputDecoration(
                            labelText: 'Observações'),
                        controller: _observacoesQuestionarioDorStart,
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
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: questionarioDorStart.questoes.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    '${questionarioDorStart.questoes[index + 1]!.ordemQuestaoDomain}. ${questionarioDorStart.questoes[index + 1]!.descricao}')),
                            MenuEscolhaPontuacaoQuestaoWidget(
                              questao: questionarioDorStart
                                  .questoes[index + 1]!,
                              opcaoInicial: index + 1 < 9 ? QuestaoQuestionarioDomain.questionarioDorStartAnswers1to8.values.toList()[0] : [...QuestaoQuestionarioDomain.questionarioDorStartAnswers9.values.toList()[0], ...QuestaoQuestionarioDomain.questionarioDorStartAnswers9.values.toList()[1]][0] as String,
                              opcoesMenu: index + 1 < 9 ? QuestaoQuestionarioDomain.questionarioDorStartAnswers1to8.values.toList() : [...QuestaoQuestionarioDomain.questionarioDorStartAnswers9.values.toList()[0], ...QuestaoQuestionarioDomain.questionarioDorStartAnswers9.values.toList()[1]] as List<String>,
                              pointsAssignmentFunction: index + 1 < 9 ? null : (String dropdownValue) {
                                questionarioDorStart.classificaoQuestao9Incomodo = dropdownValue;

                                if (QuestaoQuestionarioDomain.questionarioDorStartAnswers9[1]!.contains(dropdownValue)) {
                                  return 1;
                                } else {
                                  return 0;
                                }
                              },
                            )
                          ],
                        );
                      }),
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
                            questionarioDorStart
                                .uuidQuestionarioAplicado = generatedUuid;

                            questionarioDorStart.dataRealizacao = DateTime.now();

                            questionarioDorStart
                                    .pontuacaoQuestionario =
                                questionarioDorStart.questoes.entries
                                    .fold(
                                        0,
                                        (previousValue,
                                                element) =>
                                            previousValue +

                                            element.value.pontuacao);

                            // Registro das observações:
                            questionarioDorStart.observacoes = _observacoesQuestionarioDorStart.text;

                            // Registrar o pesquisador responsável
                            questionarioDorStart
                                    .pesquisadorResponsavel =
                                Provider.of<Pesquisador?>(context,
                                    listen: false);

                            // Campos específicos do questionário STarT Back Screening Tool- Brasil (SBST-Brasil)
                            questionarioDorStart.pontuacaoSubescalaPsicossocial = questionarioDorStart.questoes.entries.toList().sublist(5)
                                .fold(
                                0,
                                    (previousValue,
                                    element) =>
                                previousValue +

                                    element.value.pontuacao);

                            // Salvar o questionário e todos os seus registros no banco de dados Firestore Database
                            questionarioDorStart.firestoreAdd();

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultadoQuestionarioDorStartScreen(
                                      questionario:
                                          questionarioDorStart,
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
}
