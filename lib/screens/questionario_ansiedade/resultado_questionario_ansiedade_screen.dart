import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/screens/pdf_view_screen/pdf_view_screen.dart';

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
                'Data da aplicação: ${DateTimeHelper.retrieveFormattedDateStringBR(questionario.dataRealizacao)}',
                // 'Data da aplicação: ${questionario.dataRegistroQuestionario.toString()}',
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
                'Pesquisador responsável: ${questionario.pesquisadorResponsavel!.nomePesquisador}',
                // 'Data da aplicação: ${questionario.dataRegistroQuestionario.toString()}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            const Text(
              'Identificador do questionário:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SelectableText(questionario.uuidQuestionarioAplicado!),
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
                questionario.interpretacaoPontuacaoQuestionario,
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
                  'Observações:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(questionario.observacoes),
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
                            child: Text(
                                '${questionario.questoes[index + 1]!.ordemQuestaoDomain}. ${questionario.questoes[index + 1]!.descricao}')),
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
                      onPressed: () async {
                        await _generatePdf(context);
                      },
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

  Future _generatePdf(BuildContext context) async {
    final pdf = pw.Document(deflate: zlib.encode);

    double modulo = 165 / 4;

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Stack(children: <pw.Widget>[
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.BarcodeWidget(
                    color: PdfColor.fromHex('#000000'),
                    barcode: pw.Barcode.qrCode(),
                    data: questionario.uuidQuestionarioAplicado!,
                    height: 90,
                    width: 90),
              ),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        QuestionarioDomain.questionarioDomainValues[
                            QuestionarioDomain.ansiedadeBAIDomainValue]![1],
                        style: pw.TextStyle(
                          fontSize: 14.0,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'RESULTADO',
                        style: pw.TextStyle(
                          fontSize: 12.0,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        'Paciente: ${questionario.paciente.nome}',
                        style: pw.TextStyle(
                          fontSize: 12.0,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        // Improve - add internationalization
                        'Data da aplicação: ${DateTimeHelper.retrieveFormattedDateStringBR(questionario.dataRealizacao)}',
                        // 'Data da aplicação: ${questionario.dataRegistroQuestionario.toString()}',
                        style: pw.TextStyle(
                          fontSize: 12.0,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        // Improve - add internationalization
                        'Pesquisador responsável: ${questionario.pesquisadorResponsavel!.nomePesquisador}',
                        // 'Data da aplicação: ${questionario.dataRegistroQuestionario.toString()}',
                        style: pw.TextStyle(
                          fontSize: 12.0,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
            ]),
            pw.Divider(),
            pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('Observações:')),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(questionario.observacoes),
            ),
            pw.Divider(),
            pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text('SCORE:')),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                  '${questionario.pontuacaoQuestionario.toString()} - ${questionario.interpretacaoPontuacaoQuestionario}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Divider(),
            pw.ListView.builder(itemCount: questionario.questoes.length,
                itemBuilder: (context, index) {
                  return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: <pw.Widget>[
                        pw.Expanded(
                            child: pw.Text(
                                '${questionario.questoes[index + 1]!.ordemQuestaoDomain}. ${questionario.questoes[index + 1]!.descricao}')),
                        pw.Text(questionario.questoes[index + 1]!.pontuacao
                            .toString()),
                      ],
                    );
                }),
            pw.Divider(),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
              child:             pw.Table.fromTextArray(
                data: <List<String>>[
                  <String>['Escore da questão', 'Descrição'],
                  <String>['0', 'Absolutamente não'],
                  <String>['1', 'Levemente. Não me incomodou muito'],
                  <String>['2', 'Moderadamente. Foi muito desagradável mas pude suportar'],
                  <String>['3', 'Gravemente. Dificilmente pude suportar'],
                ],
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
              child:             pw.Table.fromTextArray(
                data: <List<String>>[
                  <String>['Escore total', 'Gravidade da ansiedade'],
                  <String>['0 - 7', 'Grau mínimo de ansiedade'],
                  <String>['8 - 15', 'Ansiedade leve'],
                  <String>['16 - 25', 'Ansiedade moderada'],
                  <String>['26 - 63', 'Ansiedade grave'],
                ],
              ),
            ),
          ];
        }));

    final String filename =
        'q_ans_bai_${questionario.paciente.nome.split(' ')[0].toLowerCase()}_${DateTimeHelper.retrieveFormattedDateFilename(questionario.dataRealizacao)}.pdf';

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfViewScreen(
                  doc: pdf,
                  pdfFileName: filename,
                )));

    // await Printing.sharePdf(bytes: await pdf.save(), filename: 'resultado-questionario.pdf');
  }
}
