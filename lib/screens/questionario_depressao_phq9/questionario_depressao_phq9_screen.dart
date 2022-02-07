import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/menu_escolha_pontuacao_ansiedade_widget.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_depressao_phq9_model.dart';
import 'package:vida_app/screens/questionario_depressao_phq9/questionario_depressao_phq9_resultado_screen.dart';

class QuestionarioDepressaoPHQ9Screen extends StatefulWidget {
  final Paciente paciente;

  const QuestionarioDepressaoPHQ9Screen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _QuestionarioDepressaoPHQ9ScreenState createState() =>
      _QuestionarioDepressaoPHQ9ScreenState();
}

class _QuestionarioDepressaoPHQ9ScreenState
    extends State<QuestionarioDepressaoPHQ9Screen> {
  // Uuid
  String generatedUuid = Uuid().v4();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _observacoesQuestionarioPHQ9Controller =
      TextEditingController();

  // Questionário de depressão PHQ-9 - objeto onde os dados serão salvos
  late QuestionarioDepressaoPHQ9 questionarioDepressaoPHQ9 =
  QuestionarioDepressaoPHQ9.buildFromPaciente(paciente: widget.paciente);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de depressão - PHQ-9'),
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
                    'PATIENT HEALTH QUESTIONNAIRE-9 (PHQ-9)',
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
                    () {
                      switch (widget.paciente.sexo) {
                        case 'M':
                          return 'AGORA VAMOS FALAR SOBRE COMO O SR. TEM SE SENTIDO NAS ÚLTIMAS DUAS SEMANAS.';
                        case 'F':
                          return 'AGORA VAMOS FALAR SOBRE COMO A SRA. TEM SE SENTIDO NAS ÚLTIMAS DUAS SEMANAS.';
                        default:
                          return 'AGORA VAMOS FALAR SOBRE COMO O SR. OU A SRA. TEM SE SENTIDO NAS ÚLTIMAS DUAS SEMANAS.';
                      }
                    }(),
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
                        controller: _observacoesQuestionarioPHQ9Controller,
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
                      itemCount: questionarioDepressaoPHQ9.questoes.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    '${questionarioDepressaoPHQ9.questoes[index + 1]!.ordemQuestaoDomain}. ${questionarioDepressaoPHQ9.questoes[index + 1]!.descricao}')),
                            MenuEscolhaPontuacaoQuestaoWidget(
                              questao: questionarioDepressaoPHQ9
                                  .questoes[index + 1]!,
                              opcaoInicial: index + 1 < 10 ? QuestaoQuestionarioDomain.questionarioDepressaoPHQ9Answers1to9.values.toList()[0] : QuestaoQuestionarioDomain.questionarioDepressaoPHQ9Answer10.values.toList()[0],
                              opcoesMenu: index + 1 < 10 ? QuestaoQuestionarioDomain.questionarioDepressaoPHQ9Answers1to9.values.toList() : QuestaoQuestionarioDomain.questionarioDepressaoPHQ9Answer10.values.toList(),
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
                            questionarioDepressaoPHQ9
                                .uuidQuestionarioAplicado = generatedUuid;

                            questionarioDepressaoPHQ9.dataRealizacao = DateTime.now();

                            questionarioDepressaoPHQ9
                                    .pontuacaoQuestionario =
                                questionarioDepressaoPHQ9.questoes.entries
                                    .fold(
                                        0,
                                        (previousValue,
                                                element) =>
                                            previousValue +

                                            element.value.pontuacao);

                            // Registro das observações:
                            questionarioDepressaoPHQ9.observacoes = _observacoesQuestionarioPHQ9Controller.text;



                            // Registrar o pesquisador responsável
                            questionarioDepressaoPHQ9
                                    .pesquisadorResponsavel =
                                Provider.of<Pesquisador?>(context,
                                    listen: false);

                            // Salvar o questionário e todos os seus registros no banco de dados Firestore Database
                            questionarioDepressaoPHQ9.firestoreAdd();

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultadoQuestionarioDepressaoPHQ9Screen(
                                      questionario:
                                          questionarioDepressaoPHQ9,
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
