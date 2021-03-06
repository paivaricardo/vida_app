import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/paciente_model.dart';

class PacienteSignatureModel {
  Uint8List signature;
  String? pdfUploadedUrl;
  Paciente paciente;
  DateTime dateTimeAcceptance;

  PacienteSignatureModel(
      {required this.signature,
      required this.paciente,
      required this.dateTimeAcceptance});

  static const String firestoreCollectionName = 'pacienteAssinatura';

  Map<String, dynamic> toJson() {
    return {
      'signature': pdfUploadedUrl,
      'paciente': paciente.toJson(),
      'dateTimeAcceptance': dateTimeAcceptance,
    };
  }

  Future<void> firestoreAdd() async {
    CollectionReference pacienteAssinatura =
        FirebaseFirestore.instance.collection(firestoreCollectionName);

    Uint8List savedPDF = await generatePDFConsent();

    pdfUploadedUrl = await uploadSignaturePDF(savedPDF);

    if (pdfUploadedUrl != 'Error') {
      return pacienteAssinatura.doc(paciente.uuid).set(toJson());
    } else {
      throw Exception('Error uploading the image file');
    }
  }

  Future<String> uploadSignatureImage(Uint8List imageBytes) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('consentDocuments/${paciente.uuid}.png');

    try {
      // Upload raw data.
      await ref.putData(imageBytes);

      firebase_storage.TaskSnapshot taskSnapshot =
          await ref.putData(imageBytes);

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print(e);
      return 'Error';
      // e.g, e.code == 'canceled'
    }
  }

  Future<String> uploadSignaturePDF(Uint8List pdfBytes) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('consentDocuments/${paciente.uuid}.pdf');

    try {
      // Upload raw data.
      await ref.putData(pdfBytes);

      firebase_storage.TaskSnapshot taskSnapshot = await ref.putData(pdfBytes);

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print(e);
      return 'Error';
      // e.g, e.code == 'canceled'
    }
  }

  Future<Uint8List> generatePDFConsent() async {
    final pdf = pw.Document(deflate: zlib.encode);

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              'TERMO DE ACEITE PARA TRATAMENTO DE DADOS PESSOAIS',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                  'Este termo visa o registro do consentimento livre, informado e inequ??voco pela qual o usu??rio concorda com o tratamento de seus dados pessoais e dados pessoais sens??veis referentes ?? sa??de para finalidades espec??ficas de pesquisa, em cumprimento ??s disposi????es da Lei n?? 13.709/2018 - Lei Geral de Prote????o de Dados Pessoais (LGPD).'),
            ),
            pw.Text(
                'Ao aceitar o presente termo, o usu??rio consente e concorda que a Universidade Federal do Amap?? (UNIFAP) Institui????o de Educa????o Superior (IES) localizada na Rodovia Josmar Chaves Pinto, km 02 - Jardim Marco Zero, CEP n?? 68.903-419, Curso de Farm??cia - Laborat??rio de An??lises de cl??nicas 2, no munic??pio de Macap??, no estado do Amap??, mantida pela Funda????o Universidade Federal do Amap??, pessoa jur??dica de direito p??blico - Federal, inscrita no Cadastro Nacional da Pessoa Jur??dica (CNPJ) sob o n?? 34.868.257/0001-81, endere??o de e-mail madson@unifap.br, com sede no mesmo endere??o da mantida, doravante denominada Controlador, tome decis??es referentes ao tratamento de seus dados pessoais, bem como realize o tratamento de seus dados pessoais e dados pessoais sens??veis de sa??de, envolvendo opera????es como as que se referem a coleta, produ????o, recep????o, classifica????o, utiliza????o, acesso, reprodu????o, transmiss??o, distribui????o, processamento, arquivamento, armazenamento, elimina????o, avalia????o ou controle da informa????o, modifica????o, comunica????o, transfer??ncia, difus??o ou extra????o.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Dados pessoais e dados pessoais sens??veis',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador fica autorizado a tomar decis??es referentes ao tratamento e a realizar o tratamento dos seguintes dados pessoais do Titular:'),
            pw.Text('- Nome completo'),
            pw.Text('- Data de nascimento'),
            pw.Text('- Sexo'),
            pw.Text('- Escolaridade'),
            pw.Text('- Profiss??o'),
            pw.Text('- Peso atual'),
            pw.Text('- Altura'),
            pw.Text(
                '- Conhecimento de Pr??ticas Integrativas e Complementares em Sa??de'),
            pw.Text(
                '- Quest??es de sa??de espec??ficas: ansiedade, depress??o, dor e tabagismo/cessa????o tab??gica'),
            pw.Text(
                '- Dados sobre a intensidade, frequ??ncia e in??cio do tabagismo/cessa????o tab??gica'),
            pw.Text(
                '- Dados sobre uso de medicamentos e quais medicamentos faz uso'),
            pw.Text(
                '- Dados complementares de sa??de julgados necess??rio para fins de pesquisa e tratamento com Pr??ticas Integrativas e Complementares em Sa??de'),
            pw.Text(
                '- Resultados e pontua????es alcan??adas em question??rios sobre ansiedade, depress??o, dores e tabagismo/cessa????o tab??gica, assim como apontamentos julgados necess??rios no momento da aplica????o desses question??rios'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Finalidades do Tratamento dos Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O tratamento dos dados pessoais listados neste termo tem as seguintes finalidades:'),
            pw.Text(
                '- Possibilitar que o Controlador identifique o titular e levante dados para a condu????o de pesquisas sobre a aplica????o de Pr??ticas Integrativas e Complementares em Sa??de (PICS) e seus efeitos sobre a sa??de, em especial sobre ansiedade, depress??o e tabagismo/cessa????o tab??gica, condi????es cujos n??veis ser??o mensurados por meio de aplica????o de question??rios sobre o Titular, durante atendimentos a serem realizados na unidade b??sica de sa??de da Universidade Federal do Amap?? (UNIFAP) ou no Laborat??rio de An??lises Cl??nicas 2 (LAC-2) do Curso de Farm??cia da UNIFAP.'),
            pw.Text(
                '- Possibilitar que o Controlador possa realizar estat??sticas e levantamento de dados anonimizados e an??lises de tend??ncia e regress??o linear, para a finalidade exclusiva e pesquisa sobre o impacto da aplica????o de Pr??ticas Integrativas e Complementares em Sa??de (PICS).'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Compartilhamento de Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador n??o compartilhar?? os dados pessoais do Titular com outros agentes de tratamento de dados, exceto caso isso seja indispens??vel ao cumprimento das finalidades listadas neste termo, com o prop??sito exclusivo de pesquisa, exclu??das finalidades comerciais, observados os princ??pios e as garantias estabelecidas pela Lei n?? 13.709/2018.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Seguran??a dos Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador responsabiliza-se pela manuten????o de medidas m??nimas de seguran??a, que estejam ao seu alcance e capacidade t??cnica, aptas a proteger os dados pessoais de acessos n??o autorizados e de situa????es acidentais ou il??citas de destrui????o, perda, altera????o, comunica????o ou qualquer forma de tratamento inadequado ou il??cito.'),
            pw.Text(
                'Em conformidade ao art. 48 da Lei n?? 13.709/2018, o Controlador comunicar?? ao Titular e ?? Autoridade Nacional de Prote????o de Dados (ANPD) a ocorr??ncia de incidente de seguran??a que possa acarretar risco ou dano relevante ao Titular.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'T??rmino do Tratamento dos Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador poder?? manter e tratar os dados pessoais do Titular durante todo o per??odo em que os mesmos forem pertinentes ao alcance das finalidades listadas neste termo. Dados pessoais anonimizados, sem possibilidade de associa????o ao indiv??duo, poder??o ser mantidos por per??odo indefinido.'),
            pw.Text(
                'O Titular poder?? solicitar via e-mail ou mensagem ao Controlador, a qualquer momento, que sejam eliminados os dados pessoais n??o anonimizados do Titular.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Direitos do Titular',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Titular tem direito a obter do Controlador, em rela????o aos dados por ele tratados, a qualquer momento e mediante requisi????o: I - confirma????o da exist??ncia de tratamento; II - acesso aos dados; III - corre????o de dados incompletos, inexatos ou desatualizados; IV - anonimiza????o, bloqueio ou elimina????o de dados desnecess??rios, excessivos ou tratados em desconformidade com o disposto na Lei n?? 13.709/2018; V - portabilidade dos dados a outro fornecedor de servi??o ou produto, mediante requisi????o expressa, de acordo com a regulamenta????o da autoridade nacional, observados os segredos comercial e industrial; VI - elimina????o dos dados pessoais tratados com o consentimento do titular, exceto nas hip??teses previstas no art. 16 da Lei n?? 13.709/2018; VII - informa????o das entidades p??blicas e privadas com as quais o controlador realizou uso compartilhado de dados; VIII - informa????o sobre a possibilidade de n??o fornecer consentimento e sobre as consequ??ncias da negativa; IX - revoga????o do consentimento, nos termos do ?? 5?? do art. 8?? da Lei n?? 13.709/2018.'),
          ];
        }));

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              'Direito de Revoga????o do Consentimento',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
                'Este consentimento poder?? ser revogado pelo usu??rio, a qualquer momento, mediante solicita????o via e-mail ou mensagem ao Controlador.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                  'Data e hora: ${DateTimeHelper.retrieveFormattedDateStringBR(dateTimeAcceptance)} - ${dateTimeAcceptance.hour}:${dateTimeAcceptance.minute}'),
            ),
            pw.SizedBox(
              width: 200,
              height: 100,
              child: pw.FittedBox(
                child: pw.Image(pw.MemoryImage(signature), fit: pw.BoxFit.fill),
              ),
            ),
            pw.Text(paciente.nome,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Identificador: ${paciente.uuid}'),
            pw.Text('Titular'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text('Pesquisador respons??vel pelo cadastro:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Text(paciente.pesquisadorCadastrante!.nomePesquisador),
            pw.Text('CPF: ${paciente.pesquisadorCadastrante!.cpfPesquisador}'),
          ];
        }));

    Uint8List returnedPDF = await pdf.save();

    return returnedPDF;
  }
}
