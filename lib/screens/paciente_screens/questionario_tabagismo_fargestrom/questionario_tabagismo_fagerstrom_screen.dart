import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/multiple_choice_tabagismo_fagerstrom_question_widget.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questionario_tabagismo_fagerstrom_model.dart';
import 'package:vida_app/screens/paciente_screens/questionario_tabagismo_fargestrom/questionario_tabagismo_fagerstrom_resultado_screen.dart';

class QuestionarioTabagismoFagerstromScreen extends StatefulWidget {
  final Paciente paciente;

  const QuestionarioTabagismoFagerstromScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _QuestionarioTabagismoFagerstromScreenState createState() =>
      _QuestionarioTabagismoFagerstromScreenState();
}

class _QuestionarioTabagismoFagerstromScreenState
    extends State<QuestionarioTabagismoFagerstromScreen> {
  // Uuid
  String generatedUuid = Uuid().v4();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _observacoesQuestionarioTabagismoFagerstrom =
      TextEditingController();

  // Questionário de TESTE DE FAGERSTRÖM
  late QuestionarioTabagismoFagerstrom questionarioTabagismoFagerstrom =
  QuestionarioTabagismoFagerstrom.buildFromPaciente(paciente: widget.paciente);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de tabagismo - TESTE DE FAGERSTRÖM'),
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
                    'TESTE DE FAGERSTRÖM',
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
                        decoration: InputDecoration(
                            labelText: 'Observações'),
                        controller: _observacoesQuestionarioTabagismoFagerstrom,
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
                      itemCount: questionarioTabagismoFagerstrom.questoes.length,
                      itemBuilder: (context, index) {
                        return MultipleChoiceTabagismoFagerstromQuestionWidget(question: questionarioTabagismoFagerstrom.questoes[index + 1]!);
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
                            questionarioTabagismoFagerstrom
                                .uuidQuestionarioAplicado = generatedUuid;

                            questionarioTabagismoFagerstrom.dataRealizacao = DateTime.now();

                            questionarioTabagismoFagerstrom
                                    .pontuacaoQuestionario =
                                questionarioTabagismoFagerstrom.questoes.entries
                                    .fold(
                                        0,
                                        (previousValue,
                                                element) =>
                                            previousValue +

                                            element.value.pontuacao);

                            // Registro das observações:
                            questionarioTabagismoFagerstrom.observacoes = _observacoesQuestionarioTabagismoFagerstrom.text;

                            // Registrar a interpretação do Score do questionário
                            questionarioTabagismoFagerstrom.registrarInterpretacaoScoreTabagismoFagerstrom(questionarioTabagismoFagerstrom.pontuacaoQuestionario);

                            // Registrar o pesquisador responsável
                            questionarioTabagismoFagerstrom
                                    .pesquisadorResponsavel =
                                Provider.of<Pesquisador?>(context,
                                    listen: false);

                            // Salvar o questionário e todos os seus registros no banco de dados Firestore Database
                            questionarioTabagismoFagerstrom.firestoreAdd();

                            print(questionarioTabagismoFagerstrom.toString());

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultadoQuestionarioTabagismoFagerstromScreen(
                                      questionario:
                                          questionarioTabagismoFagerstrom,
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
