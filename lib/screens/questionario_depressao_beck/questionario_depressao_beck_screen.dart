import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/multiple_choice_depressao_beck_question_widget.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questionario_depressao_beck_model.dart';
import 'package:vida_app/screens/questionario_depressao_beck/questionario_depressao_beck_resultado_screen.dart';

class QuestionarioDepressaoBeckScreen extends StatefulWidget {
  final Paciente paciente;

  const QuestionarioDepressaoBeckScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _QuestionarioDepressaoBeckScreenState createState() =>
      _QuestionarioDepressaoBeckScreenState();
}

class _QuestionarioDepressaoBeckScreenState
    extends State<QuestionarioDepressaoBeckScreen> {
  // Uuid
  String generatedUuid = Uuid().v4();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _observacoesQuestionarioBeckController =
      TextEditingController();

  // Questionário de depressão PHQ-9 - objeto onde os dados serão salvos
  late QuestionarioDepressaoBeck questionarioDepressaoBeck =
  QuestionarioDepressaoBeck.buildFromPaciente(paciente: widget.paciente);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de depressão - Beck'),
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
                    'ESCALA DE DEPRESSÃO DE BECK',
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
                    'Neste questionário existem grupos de afirmativas. Por favor leia com atenção cada uma delas e selecione a afirmativa que melhor descreve como você se sentiu na SEMANA QUE PASSOU, INCLUINDO O DIA DE HOJE.',
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
                        controller: _observacoesQuestionarioBeckController,
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
                      itemCount: questionarioDepressaoBeck.questoes.length,
                      itemBuilder: (context, index) {
                        return MultipleChoiceDepressaoBeckQuestionWidget(question: questionarioDepressaoBeck.questoes[index + 1]!);
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
                            questionarioDepressaoBeck
                                .uuidQuestionarioAplicado = generatedUuid;

                            questionarioDepressaoBeck.dataRealizacao = DateTime.now();

                            questionarioDepressaoBeck
                                    .pontuacaoQuestionario =
                                questionarioDepressaoBeck.questoes.entries
                                    .fold(
                                        0,
                                        (previousValue,
                                                element) =>
                                            previousValue +

                                            element.value.pontuacao);

                            // Registro das observações:
                            questionarioDepressaoBeck.observacoes = _observacoesQuestionarioBeckController.text;



                            // Registrar o pesquisador responsável
                            questionarioDepressaoBeck
                                    .pesquisadorResponsavel =
                                Provider.of<Pesquisador?>(context,
                                    listen: false);

                            // Salvar o questionário e todos os seus registros no banco de dados Firestore Database
                            questionarioDepressaoBeck.firestoreAdd();

                            print(questionarioDepressaoBeck.toString());

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultadoQuestionarioDepressaoBeckScreen(
                                      questionario:
                                          questionarioDepressaoBeck,
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
