import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/menu_escolha_pontuacao_ansiedade_questao_widget.dart';
import 'package:vida_app/database/dao/questionario_ansiedade_dao.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:vida_app/screens/questionario_ansiedade/resultado_questionario_ansiedade_screen.dart';

class QuestionarioAnsiedadeScreen extends StatefulWidget {
  Paciente paciente;

  QuestionarioAnsiedadeScreen(this.paciente, {Key? key}) : super(key: key);

  @override
  State<QuestionarioAnsiedadeScreen> createState() =>
      _QuestionarioAnsiedadeScreenState();
}

class _QuestionarioAnsiedadeScreenState
    extends State<QuestionarioAnsiedadeScreen> {
  // Uuid do questionário
  var generatedUuid = Uuid().v4();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // DAO - questionário de ansiedade
  final QuestionarioAnsiedadeDAO _questionarioAnsiedadeDAO = QuestionarioAnsiedadeDAO();

  // Member variables
  String? radioValuePossuiDiagnosticoAnsiedade = 'N';
  bool jaEncontraTratamento = false;

  // RegExp para validação de data
  RegExp regExpDataDesdeQuando = RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');

  // Controllers
  TextEditingController desdeQuandoPossuiDiagController =
  TextEditingController();
  TextEditingController tempoTratamentoController = TextEditingController();
  TextEditingController tratamentoAtualAnsiedadeController =
  TextEditingController();
  TextEditingController tratamentosPreviosAnsiedadeController =
  TextEditingController();

  // Mask input formatters
  MaskTextInputFormatter dateMaskFormatter =
  MaskTextInputFormatter(mask: '@#/&#/####', filter: {
    '@': RegExp(r'[0-3]'),
    '&': RegExp(r'[01]'),
    '#': RegExp(r'[0-9]'),
  });

  // Questionário de ansiedade - objeto onde os dados serão salvos
  late QuestionarioAnsiedade questionarioAnsiedadeAplicado =
  QuestionarioAnsiedade(paciente: widget.paciente);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de ansiedade'),
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
                    'BAI (INVENTÁRIO DE ANSIEDADE DE BECK)',
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
                    widget.paciente.nome.toUpperCase(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Abaixo está uma lista de sintomas comuns de ansiedade. Por favor, leia cuidadosamente cada item da lista. Identifique o quanto você tem sido incomodado por cada sintoma durante a última semana, incluindo hoje, marcando a opção correspondente, na mesma linha de cada sintoma.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Possui diagnóstico de ansiedade?'),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(-2),
                              title: Text('Não'),
                              leading: Radio(
                                value: 'N',
                                groupValue:
                                radioValuePossuiDiagnosticoAnsiedade,
                                onChanged: (String? value) {
                                  setState(() {
                                    radioValuePossuiDiagnosticoAnsiedade =
                                        value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(-2),
                              title: Text('Não sabe'),
                              leading: Radio(
                                value: 'NS',
                                groupValue:
                                radioValuePossuiDiagnosticoAnsiedade,
                                onChanged: (String? value) {
                                  setState(() {
                                    radioValuePossuiDiagnosticoAnsiedade =
                                        value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(-2),
                              title: Text('Sim'),
                              leading: Radio(
                                value: 'S',
                                groupValue:
                                radioValuePossuiDiagnosticoAnsiedade,
                                onChanged: (String? value) {
                                  setState(() {
                                    radioValuePossuiDiagnosticoAnsiedade =
                                        value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: radioValuePossuiDiagnosticoAnsiedade == 'S',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Desde quando?'),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Data do diagnóstico',
                                  hintText:
                                  'ex.: 31/12/2016 - digite apenas números'),
                              controller: desdeQuandoPossuiDiagController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [dateMaskFormatter],
                              validator: (dataDesdeQuando) {
                                if (dataDesdeQuando == null ||
                                    regExpDataDesdeQuando
                                        .hasMatch(dataDesdeQuando)) {
                                  if (dataDesdeQuando != null) {
                                    if (dateParse(dataDesdeQuando).isAfter(
                                        questionarioAnsiedadeAplicado
                                            .paciente.dataNascimento) &&
                                        dateParse(dataDesdeQuando)
                                            .isBefore(DateTime.now()) ||
                                        dateParse(dataDesdeQuando)
                                            .isAtSameMomentAs(DateTime.now())) {
                                      return null;
                                    } else {
                                      return 'A data deve estar entre o nascimento do paciente e hoje.';
                                    }
                                  }

                                  return null;
                                } else {
                                  return 'Digite uma data válida.';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('Já se encontra em tratamento da ansiedade?'),
                          Checkbox(
                              value: jaEncontraTratamento,
                              onChanged: (bool? value) {
                                setState(() {
                                  jaEncontraTratamento = value!;
                                });
                              })
                        ],
                      ),
                      Visibility(
                        visible: jaEncontraTratamento,
                        child: TextFormField(
                          decoration:
                          InputDecoration(labelText: 'Tempo de tratamento'),
                          controller: tempoTratamentoController,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Tratamento atual para ansiedade'),
                        controller: tratamentoAtualAnsiedadeController,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Tratamentos prévios para ansiedade'),
                        controller: tratamentosPreviosAnsiedadeController,
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
                      itemCount: questionarioAnsiedadeAplicado.questoes.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                                    '${questionarioAnsiedadeAplicado
                                        .questoes[index + 1]!
                                        .ordemQuestaoDomain}. ${questionarioAnsiedadeAplicado
                                        .questoes[index + 1]!.descricao}')),
                            MenuEscolhaPontuacaoQuestaoWidget(
                              questao: questionarioAnsiedadeAplicado
                                  .questoes[index + 1]!,
                              opcaoInicial: 'Absolutamente não (0)',
                              opcoesMenu: <String>[
                                'Absolutamente não (0)',
                                'Levemente (1)',
                                'Moderadamente (2)',
                                'Gravemente (3)',
                              ],
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
                            questionarioAnsiedadeAplicado
                                .uuidQuestionarioAplicado = generatedUuid;

                            questionarioAnsiedadeAplicado
                                .dataRealizacao = DateTime.now();

                            questionarioAnsiedadeAplicado
                                .pontuacaoQuestionario =
                                questionarioAnsiedadeAplicado.questoes.entries
                                    .fold(
                                    0,
                                        (previousValue,
                                        element) =>
                                    previousValue +
                                        element.value.pontuacao);

                            // Registrar a interpretação do escore no questionário de ansiedade - Inventário de Ansiedade de BAI
                            questionarioAnsiedadeAplicado
                                .registrarInterpretacaoScoreBAI(
                                questionarioAnsiedadeAplicado
                                    .pontuacaoQuestionario);

                            // Registros no questionário específico de ansiedade
                            questionarioAnsiedadeAplicado
                                .possuiDiagnosticoAnsiedade =
                            radioValuePossuiDiagnosticoAnsiedade!;

                            questionarioAnsiedadeAplicado
                                .desdeQuandoPossuiDiag =
                            desdeQuandoPossuiDiagController.text.isNotEmpty
                                ? dateParse(
                                desdeQuandoPossuiDiagController.text)
                                : null;

                            questionarioAnsiedadeAplicado.jaEncontraTratamento =
                                jaEncontraTratamento;

                            questionarioAnsiedadeAplicado.tempoTratamento =
                            tempoTratamentoController.text.isNotEmpty
                                ? tempoTratamentoController.text
                                : 'Sem tempo definido';

                            questionarioAnsiedadeAplicado
                                .tratamentoAtualAnsiedade =
                            tratamentoAtualAnsiedadeController
                                .text.isNotEmpty
                                ? tratamentoAtualAnsiedadeController.text
                                : 'Nenhum';

                            questionarioAnsiedadeAplicado
                                .tratamentosPreviosAnsiedade =
                            tratamentosPreviosAnsiedadeController
                                .text.isNotEmpty
                                ? tratamentoAtualAnsiedadeController.text
                                : 'Nenhum';

                            // Salvar o questionário e todos os seus registros no banco de dados, por meio do DAO
                            await _questionarioAnsiedadeDAO.save(questionarioAnsiedadeAplicado);

                            print(questionarioAnsiedadeAplicado.toString());

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ResultadoQuestionarioAnsiedadeScreen(
                                      questionario:
                                      questionarioAnsiedadeAplicado,
                                    )));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Alguns dados estão inválidos. Verifique os dados e tente submeter novamente.')));
                          }
                        } catch (error, stacktrace) {
                          // print(error);
                          // print(stacktrace.toString());
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

  DateTime dateParse(String date) {
    return DateTime(int.parse(date.substring(6, 10)),
        int.parse(date.substring(3, 5)), int.parse(date.substring(0, 2)));
  }
}
