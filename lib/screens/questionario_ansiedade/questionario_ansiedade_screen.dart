import 'package:flutter/material.dart';
import 'package:vida_app/components/menu_escolha_pontuacao_ansiedade_questao_widget.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/screens/questionario_ansiedade/resultado_questionario_ansiedade_screen.dart';

class QuestionarioAnsiedade extends StatelessWidget {
  QuestionarioAnsiedade({Key? key}) : super(key: key);

  final questionarioAnsiedadeModel = QuestionarioAnsiedadeModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário de ansiedade'),
      ),
      body: SingleChildScrollView(
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
                'Abaixo está uma lista de sintomas comuns de ansiedade. Por favor, leia cuidadosamente cada item da lista. Identifique o quanto você tem sido incomodado por cada sintoma durante a última semana, incluindo hoje, marcando a opção correspondente, na mesma linha de cada sintoma.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Divider(),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: questionarioAnsiedadeModel.questoes.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Text(questionarioAnsiedadeModel
                              .questoes[index + 1]!.descricao)),
                      MenuEscolhaPontuacaoQuestaoWidget(
                        questao:
                            questionarioAnsiedadeModel.questoes[index + 1]!,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCELAR'),
                ),
                ElevatedButton(
                    onPressed: () {
                      questionarioAnsiedadeModel.dataRegistroQuestionario =
                          DateTime.now();
                      questionarioAnsiedadeModel.pontuacaoTotal =
                          questionarioAnsiedadeModel.questoes.entries.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.value.pontuacao);
                      questionarioAnsiedadeModel.registrarInterpretacaoScoreBAI(questionarioAnsiedadeModel.pontuacaoTotal);
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResultadoQuestionarioAnsiedade(
                                questionario: questionarioAnsiedadeModel,
                              )));
                      print(
                          'Pontuação do questionário: ${questionarioAnsiedadeModel.pontuacaoTotal}');
                      print(
                          'Data de salvamento: ${questionarioAnsiedadeModel.dataRegistroQuestionario.toString()}');
                    },
                    child: Text('GRAVAR')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
