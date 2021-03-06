import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class PesquisadorSignatureModel {
  Uint8List signature;
  String? pdfUploadedUrl;
  Pesquisador pesquisador;
  DateTime dateTimeAcceptance;

  PesquisadorSignatureModel(
      {required this.signature,
      required this.pesquisador,
      required this.dateTimeAcceptance});

  static const String firestoreCollectionName = 'pesquisadorAssinatura';

  Map<String, dynamic> toJson() {
    return {
      'signature': pdfUploadedUrl,
      'pesquisador': pesquisador.toJson(),
      'dateTimeAcceptance': dateTimeAcceptance,
    };
  }

  Future<void> firestoreAdd() async {
    CollectionReference pesquisadorAssinatura =
        FirebaseFirestore.instance.collection(firestoreCollectionName);

    Uint8List savedPDF = await generatePDFConsent();

    pdfUploadedUrl = await uploadSignaturePDF(savedPDF);

    if (pdfUploadedUrl != 'Error') {
      return pesquisadorAssinatura.doc(pesquisador.uuidPesquisador).set(toJson());
    } else {
      throw Exception('Error uploading the image file');
    }
  }

  Future<String> uploadSignatureImage(Uint8List imageBytes) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('termoResponsabilidadeDocuments/${pesquisador.uuidPesquisador}.png');

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
        .ref('termoResponsabilidadeDocuments/${pesquisador.uuidPesquisador}.pdf');

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
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(
                  'TERMO DE RESPONSABILIDADE, SIGILO E CONFIDENCIALIDADE',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'O presente termo firma o compromisso de responsabilidade, de sigilo e confidencialidade que assume o signat??rio deste quando da utiliza????o do sistema VIDA, de propriedade da Universidade Federal do Amap?? (UNIFAP) Institui????o de Educa????o Superior (IES) localizada na Rodovia Josmar Chaves Pinto, km 02 - Jardim Marco Zero, Curso de Farm??cia - Laborat??rio de An??lises de Cl??nicas 2, CEP n?? 68.903-419, no munic??pio de Macap??, no estado do Amap??, mantida pela Funda????o Universidade Federal do Amap??, pessoa jur??dica de direito p??blico - Federal, inscrita no Cadastro Nacional da Pessoa Jur??dica (CNPJ) sob o n?? 34.868.257/0001-81, com sede no mesmo endere??o da mantida. '),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Seguem abaixo as disposi????es e condi????es que regem este termo:'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 1??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text('Para fins do presente termo entende-se por:'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Pesquisador: todo aquele que opera o sistema e cujo perfil de acesso define as restri????es em face das informa????es cadastradas e as funcionalidades dos sistemas. Estes perfis podem ser: coordenador, mestrando, inicia????o cient??fica e estagi??rio. O pesquisador coordenador corresponder?? ao administrador do sistema e ser?? respons??vel pelo cadastramento de todos os outros perfis de pesquisadores, al??m de ter poderes para autorizar ou desautorizar outros pesquisadores a acessar o sistema.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Informa????o confidencial: toda e qualquer informa????o, seja verbal, escrita ou gravada em meio digital, relativa ao paciente cadastrado no aplicativo VIDA, ou ?? comunidade atendida, o que inclui, mas n??o se limita a: dados pessoais do paciente como nome, data de nascimento, profiss??o, altura, peso, conhecimento de Pr??ticas Integrativas e Complementares em Sa??de (PICS), dados pessoais sens??veis do paciente como condi????o de sa??de, medicamentos que faz uso, observa????es e notas diversas tomadas durante a utiliza????o do aplicativo, question??rios de sa??de aplicados sobre os pacientes, tais como: BAI (INVENT??RIO DE ANSIEDADE DE BECK), Patient Health Questionnaire-9 (PHQ-9), ESCALA DE DEPRESS??O DE BECK, INVENT??RIO BREVE DA DOR, STarT Back Screening Tool - Brasil (SBST-Brasil), TESTE DE FAGERSTR??M, entre outros, demais dados t??cnicos, pessoais ou n??o, banco de dados, metodologias, entre outros disponibilizados aos pesquisadores ou aos quais estes tenham acesso em raz??o da utiliza????o do aplicativo ou do v??nculo com o Laborat??rio de An??lises de cl??nicas 2 da Universidade Federal do Amap??, bem como presta????o de servi??os ou de qualquer outra natureza.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Aplicativo VIDA - O aplicativo VIDA ?? um sistema desenvolvido para dispositivos m??veis com o prop??sito de auxiliar na pesquisa conduzida no Curso de Farm??cia - Laborat??rio de An??lises de cl??nicas 2 da Universidade Federal do Amap??, referente ?? aplica????o de Pr??ticas Integrativas e Complementares em Sa??de (PICS) e acompanhamento de pacientes por meio da aplica????o dos question??rios mencionados na defini????o de informa????o confidencial, com funcionalidades de cadastramento de pacientes, aplica????o de question??rios, registro de interven????es de PICS, visualiza????o de hist??rico de question??rios e interven????es j?? aplicadas, resgate informa????es de question??rios anteriores e exporta????o de PDFs.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 2??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'A cada usu??rio ser?? atribu??da uma senha de acesso para um perfil, a qual ?? sigilosa, de uso pessoal e intransfer??vel. A primeira senha gerada no momento do cadastro ser?? provis??ria e fornecida pelo pesquisador coordenador. O sistema obrigar?? a troca da senha no primeiro acesso, momento a partir do qual a senha dever?? ser mantida em sigilo, sendo vedado o seu compartilhamento com qualquer outra pessoa. A responsabilidade pelo uso e guarda da senha ?? atribu??da integralmente ao pesquisador, inclusive pelos danos advindos da sua revela????o indevida.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'O pesquisador com o perfil de coordenador ?? o respons??vel por autorizar e bloquear o acesso aos sistemas dos pesquisadores subordinados a ele. Pesquisadores que n??o mais participarem do projeto de pesquisa ou que perderem o v??nculo com a Universidade Federal do Amap?? (UNIFAP) dever??o ser desautorizados do uso do sistema, por meio das funcionalidades presentes no pr??prio aplicativo.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 3??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'O pesquisador cadastrado dever?? utilizar o Aplicativo Vida para finalidades exclusivas de pesquisa e atendimento ?? comunidade no Laborat??rio de An??lises de Cl??nicas 2 - Curso de Farm??cia, conforme definido no escopo do projeto de pesquisa e nas linhas aprovadas pelo comit?? de ??tica da Universidade Federal do Amap??, sendo vedada a utiliza????o do sistema para fins estranhos ao projeto de pesquisa, em viola????o a este termo de responsabilidade, sigilo e confidencialidade.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 4??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'Quaisquer publica????es cient??ficas ou acad??micas realizadas com utiliza????o das informa????es contidas ou geradas pelo Aplicativo Vida dever??o ser anonimizadas e agregadas, n??o podendo conter nenhum dado apto a identificar o paciente, obedecendo ao disposto no art. 5o, incisos III e XI, art. 7??, inciso IV, art. 11, al??nea ???c???, art. 12, art. 16, inciso II, art. 18, inciso IV, da Lei n?? 13.709 - Lei Geral de Prote????o de Dados Pessoais (LGPD).'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 5??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'A Universidade Federal do Amap?? n??o tolerar??, em hip??tese alguma, divulga????o das informa????es confidenciais ou viola????o deste termo de responsabilidade.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 6??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'Aos pesquisadores do Aplicativo VIDA, fica desde j?? proibido:'),
                pw.Text(
                    '6.1 - Utilizar informa????es internas em benef??cio pr??prio ou de terceiros, para finalidades outras que n??o as permitidas pela legisla????o;'),
                pw.Text(
                    '6.2 - Utilizar as informa????es internas ou de sa??de dos pacientes cadastrados para fins comerciais ou finalidades lucrativas ou econ??micas de qualquer natureza;'),
                pw.Text(
                    '6.3 - Divulgar quaisquer informa????es relativas ao Aplicativo VIDA, aos seus clientes ou terceiros, ressalvando-se o disposto na legisla????o;'),
                pw.Text(
                    '6.4 - Divulgar quaisquer informa????es referentes aos projetos de inform??tica, equipamentos, sistemas operacionais, softwares, sistemas de controles referentes ao Aplicativo VIDA e outros aqui envolvidos;'),
                pw.Text(
                    '6.5 - Falar em nome do Aplicativo VIDA ou da Universidade Federal do Amap?? sem a aquiesc??ncia expressa da administra????o da Universidade ou do coordenador do projeto de pesquisa;'),
                pw.Text(
                    '6.6 - Reproduzirem no todo ou em parte, documentos, softwares ou qualquer outra informa????o, para uso pr??prio ou de terceiros, fora do escopo da pesquisa, conforme as linhas estabelecidas pelo comit?? de ??tica da Universidade Federal do Amap??, seja dentro ou fora do estabelecimento universit??rio, de atendimento ou pesquisa;'),
                pw.Text(
                    '6.7 - Fazer transitar por qualquer meio, quaisquer informa????es que n??o sejam de dom??nio p??blico, sem consentimento da administra????o da Universidade Federal do Amap?? ou fora dos estritos limites de pesquisa, devidamente aprovada pelo Comit?? de ??tica ;'),
                pw.Text(
                    '6.8 - Fornecer a senha de acesso ao Aplicativo VIDA a terceiros ou n??o observar a devida cautela na sua guarda e sigilo.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 7??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'O descumprimento do presente Termo, tendo sido previamente aceito, sujeitar?? o infrator ??s san????es na esfera administrativa, sem preju??zo de eventuais a????es nas esferas civil e criminal, respondendo pela extens??o dos danos direta ou indiretamente causados ?? Universidade Federal do Amap??, seu corpo discente ou docente, ou ?? comunidade atendida no Laborat??rio de An??lises de Cl??nicas 2 / Unidade B??sica de Sa??de (UBS) da UNIFAP, inclusive por lucros cessantes, danos materiais e/ou morais, bem como viola????es ao estabelecido na Lei Geral de Prote????o de Dados Pessoais (LGPD), mesmo que a divulga????o das informa????es confidenciais ocorram ap??s o fim do projeto de pesquisa ou o desligamento do pesquisador da Universidade Federal do Amap??, ou ainda, ap??s a utiliza????o do sistema.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 8??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text('Ficam exclu??das do presente termo as informa????es:'),
                pw.Text(
                    'a) que sejam de dom??nio p??blico (Lei n?? 9.610, de 19 de fevereiro de 1998- http://www.dominiopublico.gov.br);'),
                pw.Text(
                    'b) informa????es que venham a ser disponibilizadas para o p??blico, de outra forma que n??o seja por meio de divulga????o por parte dos pesquisadores e prestadores de servi??os da Universidade Federal do Amap??;'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cl??usula 9??',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'As obriga????es de confidencialidade contidas neste instrumento ter??o validade por prazo indeterminado, ficando os pesquisadores e demais prestadores de servi??os adstritos aos seus termos mesmo ap??s o t??rmino do Contrato.'),
              ],
            ),
          ];
        }));

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Cl??usula 10??',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'No caso de d??vidas quanto ao correto procedimento a ser tomado para garantir o sigilo dos dados, dever?? ser consultado o coordenador do projeto de pesquisa, ou a administra????o da Universidade Federal do Amap??.'),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Cl??usula 11??',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'A Universidade Federal do Amap?? tem o direito de, a qualquer momento, modificar, alterar ou retirar quaisquer pol??ticas ou procedimentos, adicionar outros que se fa??am necess??rios para o perfeito funcionamento do sistema, mediante simples aviso por circular.'),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                  'Por concordar com a reda????o supra e do inequ??voco compromisso firmado, declaro ci??ncia e concord??ncia, aderindo a todos os termos e condi????es ora estabelecidos.'),
            ),
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
            pw.Text(pesquisador.nomePesquisador,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('CPF: ${pesquisador.cpfPesquisador}'),
            pw.Text('Pesquisador'),
          ];
        }));

    Uint8List returnedPDF = await pdf.save();

    return returnedPDF;
  }
}
