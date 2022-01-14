import 'package:flutter/material.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';

class ResultadoQuestionarioAnsiedadeScreen extends StatelessWidget {
  final QuestionarioAnsiedade questionario;

  ResultadoQuestionarioAnsiedadeScreen({required this.questionario, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do questionário de ansiedade'),
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
                'RESULTADO',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Paciente: ${questionario.paciente.nome}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                // Improve - add internationalization
                'Data da aplicação: ${questionario.dataAplicacaoQuestionario!.day}/${questionario.dataAplicacaoQuestionario!.month}/${questionario.dataAplicacaoQuestionario!.year}',
                // 'Data da aplicação: ${questionario.dataRegistroQuestionario.toString()}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'SCORE: ${questionario.pontuacaoQuestionario.toString()}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                questionario.interpretacaoScoreBAI!,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: questionario.questoes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                            child: Text('${questionario.questoes[index + 1]!.ordemQuestaoDomain}. ${questionario.questoes[index + 1]!.descricao}')),
                        Text(questionario.questoes[index + 1]!.pontuacao
                            .toString()),
                      ],
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                'Interpretação do Escore Total do BAI',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataTable(columns: [
              DataColumn(label: Text('Escore Total')),
              DataColumn(label: Text('Gravidade da ansiedade'))
            ], rows: [
              DataRow(
                cells: [
                  DataCell(Text('0 - 7')),
                  DataCell(Text('Grau mínimo de ansiedade')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('8 - 15')),
                  DataCell(Text('Ansiedade leve')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('16 - 25')),
                  DataCell(Text('Ansiedade moderada')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('26 - 63')),
                  DataCell(Text('Ansiedade grave')),
                ],
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded),
                    label: Text('RETORNAR'),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('GERAR PDF')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
