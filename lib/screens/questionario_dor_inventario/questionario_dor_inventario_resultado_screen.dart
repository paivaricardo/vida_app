import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:vida_app/components/slider_questionario_dor_inventario.dart';
import 'package:vida_app/components/slider_questionario_dor_inventario_percentage.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_dor_inventario_model.dart';
import 'package:vida_app/screens/pdf_view_screen/pdf_view_screen.dart';

class ResultadoQuestionarioDorInventarioScreen extends StatelessWidget {
  final QuestionarioDorInventario questionario;

  ResultadoQuestionarioDorInventarioScreen(
      {required this.questionario, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double modulo = (MediaQuery.of(context).size.width * 0.9) / 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do questionário de dor'),
      ),
      body: SingleChildScrollView(
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
                  'Observações:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(questionario.observacoes),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Column(
                children: <Widget>[
                  Text(QuestaoQuestionarioDomain
                      .questionarioDorInventarioQuestoesValues[1]!),
                  ListTile(
                    title: Text('Sim'),
                    leading: Radio<int>(
                      groupValue: questionario.questoes[1]!.pontuacao,
                      value: 1,
                      onChanged: (value) {},
                    ),
                  ),
                  ListTile(
                    title: Text('Não'),
                    leading: Radio<int>(
                      groupValue: questionario.questoes[1]!.pontuacao,
                      value: 0,
                      onChanged: (value) {},
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
                      children: _returnListButtonsBodyParts(
                          modulo: modulo, side: 'front'),
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
                      children: _returnListButtonsBodyParts(
                          modulo: modulo, side: 'back'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[3]!),
                  ),
                  SliderQuestionarioDorInventario(
                      enabled: false, questao: questionario.questoes[3]!),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[4]!),
                  ),
                  SliderQuestionarioDorInventario(
                      enabled: false, questao: questionario.questoes[4]!),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[5]!),
                  ),
                  SliderQuestionarioDorInventario(
                      enabled: false, questao: questionario.questoes[5]!),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[6]!),
                  ),
                  SliderQuestionarioDorInventario(
                      enabled: false, questao: questionario.questoes[6]!),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[7]!),
                  ),
                  returnMedicineList(modulo),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[8]!),
                  ),
                  SliderQuestionarioDorInventarioPercentage(
                      enabled: false, questao: questionario.questoes[8]!),
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
                    enabled: false,
                    questao: questionario.questoes[10]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[11]!),
                  ),
                  SliderQuestionarioDorInventario(
                    enabled: false,
                    questao: questionario.questoes[11]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[12]!),
                  ),
                  SliderQuestionarioDorInventario(
                    enabled: false,
                    questao: questionario.questoes[12]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[13]!),
                  ),
                  SliderQuestionarioDorInventario(
                    enabled: false,
                    questao: questionario.questoes[13]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[14]!),
                  ),
                  SliderQuestionarioDorInventario(
                    enabled: false,
                    questao: questionario.questoes[14]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[15]!),
                  ),
                  SliderQuestionarioDorInventario(
                    enabled: false,
                    questao: questionario.questoes[15]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(QuestaoQuestionarioDomain
                        .questionarioDorInventarioQuestoesValues[16]!),
                  ),
                  SliderQuestionarioDorInventario(
                    enabled: false,
                    questao: questionario.questoes[16]!,
                    beginLabel: 'Não interferiu',
                    endLabel: 'Interferiu completamente',
                  ),
                ],
              ),
            ),
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
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _returnListButtonsBodyParts({required side, required modulo}) {
    List<Widget> returnedWidgets = <Widget>[];

    List<String> stringifiedFrontBodyPartsIndexes = QuestionarioDorInventario
        .frontBodyPartsIndexes
        .map((bodyPart) => bodyPart.toString())
        .toList();
    List<String> stringifiedBackBodyPartsIndexes = QuestionarioDorInventario
        .backBodyPartsIndexes
        .map((bodyPart) => bodyPart.toString())
        .toList();
    List<MapEntry<String, int>> painMapBodyEntries =
        questionario.painMapBody.entries.toList();

    switch (side) {
      case 'front':
        for (int index in List.from(painMapBodyEntries
            .where((entry) =>
                entry.value == 1 &&
                stringifiedFrontBodyPartsIndexes.contains(entry.key))
            .map((entry) => int.parse(entry.key)))) {
          returnedWidgets.add(Positioned(
              width: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['size']!,
              height: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['size']!,
              top: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['top']!,
              left: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['left']!,
              child: ClipOval(
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    color: Colors.purple,
                  ),
                ),
              )));
        }
        return returnedWidgets;
      case 'back':
        for (int index in List.from(painMapBodyEntries
            .where((entry) =>
                entry.value == 1 &&
                stringifiedBackBodyPartsIndexes.contains(entry.key))
            .map((entry) => int.parse(entry.key)))) {
          returnedWidgets.add(Positioned(
              width: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['size']!,
              height: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['size']!,
              top: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['top']!,
              left: modulo *
                  QuestionarioDorInventario
                      .modularizedBodyPartsPositions[index]!['left']!,
              child: ClipOval(
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    color: Colors.purple,
                  ),
                ),
              )));
        }
        return returnedWidgets;
      default:
        return returnedWidgets;
    }
  }

  List<pw.Widget> _returnMarkingsBodyPartsPDF(
      {required side, required modulo}) {
    List<pw.Widget> returnedWidgets = <pw.Widget>[];

    List<String> stringifiedFrontBodyPartsIndexes = QuestionarioDorInventario
        .frontBodyPartsIndexes
        .map((bodyPart) => bodyPart.toString())
        .toList();
    List<String> stringifiedBackBodyPartsIndexes = QuestionarioDorInventario
        .backBodyPartsIndexes
        .map((bodyPart) => bodyPart.toString())
        .toList();
    List<MapEntry<String, int>> painMapBodyEntries =
        questionario.painMapBody.entries.toList();

    switch (side) {
      case 'front':
        for (int index in List.from(painMapBodyEntries
            .where((entry) =>
                entry.value == 1 &&
                stringifiedFrontBodyPartsIndexes.contains(entry.key))
            .map((entry) => int.parse(entry.key)))) {
          returnedWidgets.add(pw.Positioned(
            top: modulo *
                QuestionarioDorInventario
                    .modularizedBodyPartsPositions[index]!['top']!,
            left: modulo *
                QuestionarioDorInventario
                    .modularizedBodyPartsPositions[index]!['left']!,
            child: pw.ClipOval(
              child: pw.Opacity(
                opacity: 0.7,
                child: pw.Container(
                  color: PdfColor.fromHex('#a831ad'),
                  width: modulo * 0.3,
                  height: modulo * 0.3,
                ),
              ),
            ),
          ));
        }
        return returnedWidgets;
      case 'back':
        for (int index in List.from(painMapBodyEntries
            .where((entry) =>
                entry.value == 1 &&
                stringifiedBackBodyPartsIndexes.contains(entry.key))
            .map((entry) => int.parse(entry.key)))) {
          returnedWidgets.add(pw.Positioned(
            top: modulo *
                QuestionarioDorInventario
                    .modularizedBodyPartsPositions[index]!['top']!,
            left: modulo *
                QuestionarioDorInventario
                    .modularizedBodyPartsPositions[index]!['left']!,
            child: pw.ClipOval(
              child: pw.Opacity(
                opacity: 0.7,
                child: pw.Container(
                  color: PdfColor.fromHex('#a831ad'),
                  width: modulo * 0.3,
                  height: modulo * 0.3,
                ),
              ),
            ),
          ));
        }
        return returnedWidgets;
      default:
        return returnedWidgets;
    }
  }

  Widget returnMedicineList(modulo) {
    if (questionario.medicineList.isEmpty) {
      return Text('Não há registro de medicamentos.');
    } else {
      return FittedBox(
        child: DataTable(columns: <DataColumn>[
          DataColumn(label: Text('Nome do medicamento')),
          DataColumn(label: Text('Dose')),
          DataColumn(label: Text('Data de início')),
        ], rows: List<DataRow>.from(questionario.medicineList.map((Map<String, dynamic>? medicine) {
          return DataRow(cells:
          <DataCell>[
            DataCell(Text(medicine!['nomeMedicamento'])),
            DataCell(Text(medicine['doseMedicamento'])),
            DataCell(Text(DateTimeHelper.retrieveFormattedDateStringBR(
          medicine['dataInicioMedicamento']))),
          ]);
        }))
        ),
      );
    }
  }

  pw.Widget returnMedicineListPDF() {
    if (questionario.medicineList.isEmpty) {
      return pw.Text('Não há registro de medicamentos.');
    } else {
      return pw.Table.fromTextArray(data: <List<String>>[
        <String>['Nome', 'Dose/Frequência', 'Data de início'],
        ...List.from(
            questionario.medicineList.map((Map<String, dynamic>? medicine) {
          return <String>[
            medicine!['nomeMedicamento'],
            medicine['doseMedicamento'],
            DateTimeHelper.retrieveFormattedDateStringBR(
                medicine['dataInicioMedicamento'])
          ];
        }))
      ]);
    }
  }

  Future _generatePdf(BuildContext context) async {
    final pdf = pw.Document(deflate: zlib.encode);

    double modulo = 165 / 4;

    // Load images to pdf
    final pw.MemoryImage imageBodyFront = pw.MemoryImage(
        (await rootBundle.load('assets/images/inventario_dor_body_front.png'))
            .buffer
            .asUint8List());
    final pw.MemoryImage imageBodyBack = pw.MemoryImage(
        (await rootBundle.load('assets/images/inventario_dor_body_back.png'))
            .buffer
            .asUint8List());

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
                        'INVENTÁRIO BREVE DA DOR',
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
            pw.Text(QuestaoQuestionarioDomain
                .questionarioDorInventarioQuestoesValues[1]!),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 12.0),
              child: pw.Text(
                  questionario.questoes[1]!.pontuacao == 1 ? 'Sim' : 'Não',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Text(QuestaoQuestionarioDomain
                .questionarioDorInventarioQuestoesValues[2]!),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: <pw.Widget>[
                pw.Container(
                  width: modulo * 4,
                  height: modulo * 4 * 2.34,
                  child: pw.Stack(children: <pw.Widget>[
                    pw.Image(imageBodyFront, fit: pw.BoxFit.cover),
                    ..._returnMarkingsBodyPartsPDF(
                        side: 'front', modulo: modulo),
                  ]),
                ),
                pw.Container(
                    width: modulo * 4,
                    height: modulo * 4 * 2.34,
                    child: pw.Stack(children: <pw.Widget>[
                      pw.Image(imageBodyBack, fit: pw.BoxFit.cover),
                      ..._returnMarkingsBodyPartsPDF(
                          side: 'back', modulo: modulo),
                    ])),
              ],
            ),
            pw.Text(QuestaoQuestionarioDomain
                .questionarioDorInventarioQuestoesValues[3]!),
            pw.Text(questionario.questoes[3]!.pontuacao.toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12),
              child: pw.Text(QuestaoQuestionarioDomain
                  .questionarioDorInventarioQuestoesValues[4]!),
            ),
            pw.Text(questionario.questoes[4]!.pontuacao.toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12),
              child: pw.Text(QuestaoQuestionarioDomain
                  .questionarioDorInventarioQuestoesValues[5]!),
            ),
            pw.Text(questionario.questoes[5]!.pontuacao.toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12),
              child: pw.Text(QuestaoQuestionarioDomain
                  .questionarioDorInventarioQuestoesValues[6]!),
            ),
            pw.Text(questionario.questoes[6]!.pontuacao.toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 12),
              child: pw.Text(QuestaoQuestionarioDomain
                  .questionarioDorInventarioQuestoesValues[7]!),
            ),
            returnMedicineListPDF(),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12),
              child: pw.Text(QuestaoQuestionarioDomain
                  .questionarioDorInventarioQuestoesValues[8]!),
            ),
            pw.Text('${questionario.questoes[8]!.pontuacao.toString()}%',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 12),
              child: pw.Text(QuestaoQuestionarioDomain
                  .questionarioDorInventarioQuestoesValues[9]!),
            ),
            pw.Table.fromTextArray(data: <List<String>>[
              <String>['Descrição', 'Pontuação'],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[10]!,
                questionario.questoes[10]!.pontuacao.toString()
              ],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[11]!,
                questionario.questoes[11]!.pontuacao.toString()
              ],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[12]!,
                questionario.questoes[12]!.pontuacao.toString()
              ],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[13]!,
                questionario.questoes[13]!.pontuacao.toString()
              ],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[14]!,
                questionario.questoes[14]!.pontuacao.toString()
              ],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[15]!,
                questionario.questoes[15]!.pontuacao.toString()
              ],
              <String>[
                QuestaoQuestionarioDomain
                    .questionarioDorInventarioQuestoesValues[16]!,
                questionario.questoes[16]!.pontuacao.toString()
              ],
            ]),
          ];
        }));

    final String filename =
        'q_inv_dor_${questionario.paciente.nome.split(' ')[0].toLowerCase()}_${DateTimeHelper.retrieveFormattedDateFilename(questionario.dataRealizacao)}.pdf';

    // final output = await getExternalStorageDirectory();
    // final File file = File('${output!.path}/$filename');
    // await file.writeAsBytes(await pdf.save());
    // print('PDF gerado em : ${file.path}!');

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
