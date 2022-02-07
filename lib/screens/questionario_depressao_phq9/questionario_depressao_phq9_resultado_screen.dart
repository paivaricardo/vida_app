import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_depressao_phq9_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/screens/pdf_view_screen/pdf_view_screen.dart';

class ResultadoQuestionarioDepressaoPHQ9Screen extends StatelessWidget {
  final QuestionarioDepressaoPHQ9 questionario;

  ResultadoQuestionarioDepressaoPHQ9Screen({required this.questionario, Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do questionário de depressão PHQ-9'),
      ),
      body: SingleChildScrollView(
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                            '${questionario.questoes[index + 1]!.ordemQuestaoDomain}. ${questionario.questoes[index + 1]!.descricao}'),
                      ),
                          (){
                        if (questionario.questoes[index + 1]!.ordemQuestaoDomain <= 9) {
                          return Text('(${questionario.questoes[index + 1]!.pontuacao}) ${
                              QuestaoQuestionarioDomain
                                  .questionarioDepressaoPHQ9Answers1to9[
                              questionario.questoes[index + 1]!.pontuacao]!
                          }', style: TextStyle(fontWeight: FontWeight.bold));
                        } else {
                          return Text('(${questionario.questoes[index + 1]!.pontuacao}) ${
                              QuestaoQuestionarioDomain
                                  .questionarioDepressaoPHQ9Answer10[
                              questionario.questoes[index + 1]!.pontuacao]!
                          }', style: TextStyle(fontWeight: FontWeight.bold));
                        }
                      }(),
                    ],
                  );
                }),
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
                        QuestionarioDomain.depressaoPHQ9DomainValue]![1],
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
                  questionario.pontuacaoQuestionario.toString(),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Divider(),
            pw.ListView.builder(itemCount: questionario.questoes.length,
                itemBuilder: (context, index) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Padding(
                        padding: pw.EdgeInsets.only(top: 12),
                        child: pw.Text(
                            '${questionario.questoes[index + 1]!.ordemQuestaoDomain}. ${questionario.questoes[index + 1]!.descricao}'),
                      ),
                      (){
                        if (questionario.questoes[index + 1]!.ordemQuestaoDomain <= 9) {
                          return pw.Text('(${questionario.questoes[index + 1]!.pontuacao}) ${
                            QuestaoQuestionarioDomain
                                    .questionarioDepressaoPHQ9Answers1to9[
                                questionario.questoes[index + 1]!.pontuacao]!
                          }', style: pw.TextStyle(fontWeight: pw.FontWeight.bold));
                        } else {
                          return pw.Text('(${questionario.questoes[index + 1]!.pontuacao}) ${
                            QuestaoQuestionarioDomain
                                    .questionarioDepressaoPHQ9Answer10[
                                questionario.questoes[index + 1]!.pontuacao]!
                          }', style: pw.TextStyle(fontWeight: pw.FontWeight.bold));
                        }
                      }(),
                    ],
                  );
                }),
          ];
        }));

    final String filename =
        'q_depre_phq9_${questionario.paciente.nome.split(' ')[0].toLowerCase()}_${DateTimeHelper.retrieveFormattedDateFilename(questionario.dataRealizacao)}.pdf';

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
