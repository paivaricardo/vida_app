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
                      'O presente termo firma o compromisso de responsabilidade, de sigilo e confidencialidade que assume o signatário deste quando da utilização do sistema VIDA, de propriedade da Universidade Federal do Amapá (UNIFAP) Instituição de Educação Superior (IES) localizada na Rodovia Josmar Chaves Pinto, km 02 - Jardim Marco Zero, Curso de Farmácia - Laboratório de Análises de Clínicas 2, CEP nº 68.903-419, no município de Macapá, no estado do Amapá, mantida pela Fundação Universidade Federal do Amapá, pessoa jurídica de direito público - Federal, inscrita no Cadastro Nacional da Pessoa Jurídica (CNPJ) sob o nº 34.868.257/0001-81, com sede no mesmo endereço da mantida. '),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Seguem abaixo as disposições e condições que regem este termo:'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 1ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text('Para fins do presente termo entende-se por:'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Pesquisador: todo aquele que opera o sistema e cujo perfil de acesso define as restrições em face das informações cadastradas e as funcionalidades dos sistemas. Estes perfis podem ser: coordenador, mestrando, iniciação científica e estagiário. O pesquisador coordenador corresponderá ao administrador do sistema e será responsável pelo cadastramento de todos os outros perfis de pesquisadores, além de ter poderes para autorizar ou desautorizar outros pesquisadores a acessar o sistema.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Informação confidencial: toda e qualquer informação, seja verbal, escrita ou gravada em meio digital, relativa ao paciente cadastrado no aplicativo VIDA, ou à comunidade atendida, o que inclui, mas não se limita a: dados pessoais do paciente como nome, data de nascimento, profissão, altura, peso, conhecimento de Práticas Integrativas e Complementares em Saúde (PICS), dados pessoais sensíveis do paciente como condição de saúde, medicamentos que faz uso, observações e notas diversas tomadas durante a utilização do aplicativo, questionários de saúde aplicados sobre os pacientes, tais como: BAI (INVENTÁRIO DE ANSIEDADE DE BECK), Patient Health Questionnaire-9 (PHQ-9), ESCALA DE DEPRESSÃO DE BECK, INVENTÁRIO BREVE DA DOR, STarT Back Screening Tool - Brasil (SBST-Brasil), TESTE DE FAGERSTRÖM, entre outros, demais dados técnicos, pessoais ou não, banco de dados, metodologias, entre outros disponibilizados aos pesquisadores ou aos quais estes tenham acesso em razão da utilização do aplicativo ou do vínculo com o Laboratório de Análises de clínicas 2 da Universidade Federal do Amapá, bem como prestação de serviços ou de qualquer outra natureza.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'Aplicativo VIDA - O aplicativo VIDA é um sistema desenvolvido para dispositivos móveis com o propósito de auxiliar na pesquisa conduzida no Curso de Farmácia - Laboratório de Análises de clínicas 2 da Universidade Federal do Amapá, referente à aplicação de Práticas Integrativas e Complementares em Saúde (PICS) e acompanhamento de pacientes por meio da aplicação dos questionários mencionados na definição de informação confidencial, com funcionalidades de cadastramento de pacientes, aplicação de questionários, registro de intervenções de PICS, visualização de histórico de questionários e intervenções já aplicadas, resgate informações de questionários anteriores e exportação de PDFs.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 2ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'A cada usuário será atribuída uma senha de acesso para um perfil, a qual é sigilosa, de uso pessoal e intransferível. A primeira senha gerada no momento do cadastro será provisória e fornecida pelo pesquisador coordenador. O sistema obrigará a troca da senha no primeiro acesso, momento a partir do qual a senha deverá ser mantida em sigilo, sendo vedado o seu compartilhamento com qualquer outra pessoa. A responsabilidade pelo uso e guarda da senha é atribuída integralmente ao pesquisador, inclusive pelos danos advindos da sua revelação indevida.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                      'O pesquisador com o perfil de coordenador é o responsável por autorizar e bloquear o acesso aos sistemas dos pesquisadores subordinados a ele. Pesquisadores que não mais participarem do projeto de pesquisa ou que perderem o vínculo com a Universidade Federal do Amapá (UNIFAP) deverão ser desautorizados do uso do sistema, por meio das funcionalidades presentes no próprio aplicativo.'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 3ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'O pesquisador cadastrado deverá utilizar o Aplicativo Vida para finalidades exclusivas de pesquisa e atendimento à comunidade no Laboratório de Análises de Clínicas 2 - Curso de Farmácia, conforme definido no escopo do projeto de pesquisa e nas linhas aprovadas pelo comitê de ética da Universidade Federal do Amapá, sendo vedada a utilização do sistema para fins estranhos ao projeto de pesquisa, em violação a este termo de responsabilidade, sigilo e confidencialidade.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 4ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'Quaisquer publicações científicas ou acadêmicas realizadas com utilização das informações contidas ou geradas pelo Aplicativo Vida deverão ser anonimizadas e agregadas, não podendo conter nenhum dado apto a identificar o paciente, obedecendo ao disposto no art. 5o, incisos III e XI, art. 7º, inciso IV, art. 11, alínea “c”, art. 12, art. 16, inciso II, art. 18, inciso IV, da Lei nº 13.709 - Lei Geral de Proteção de Dados Pessoais (LGPD).'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 5ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'A Universidade Federal do Amapá não tolerará, em hipótese alguma, divulgação das informações confidenciais ou violação deste termo de responsabilidade.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 6ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'Aos pesquisadores do Aplicativo VIDA, fica desde já proibido:'),
                pw.Text(
                    '6.1 - Utilizar informações internas em benefício próprio ou de terceiros, para finalidades outras que não as permitidas pela legislação;'),
                pw.Text(
                    '6.2 - Utilizar as informações internas ou de saúde dos pacientes cadastrados para fins comerciais ou finalidades lucrativas ou econômicas de qualquer natureza;'),
                pw.Text(
                    '6.3 - Divulgar quaisquer informações relativas ao Aplicativo VIDA, aos seus clientes ou terceiros, ressalvando-se o disposto na legislação;'),
                pw.Text(
                    '6.4 - Divulgar quaisquer informações referentes aos projetos de informática, equipamentos, sistemas operacionais, softwares, sistemas de controles referentes ao Aplicativo VIDA e outros aqui envolvidos;'),
                pw.Text(
                    '6.5 - Falar em nome do Aplicativo VIDA ou da Universidade Federal do Amapá sem a aquiescência expressa da administração da Universidade ou do coordenador do projeto de pesquisa;'),
                pw.Text(
                    '6.6 - Reproduzirem no todo ou em parte, documentos, softwares ou qualquer outra informação, para uso próprio ou de terceiros, fora do escopo da pesquisa, conforme as linhas estabelecidas pelo comitê de ética da Universidade Federal do Amapá, seja dentro ou fora do estabelecimento universitário, de atendimento ou pesquisa;'),
                pw.Text(
                    '6.7 - Fazer transitar por qualquer meio, quaisquer informações que não sejam de domínio público, sem consentimento da administração da Universidade Federal do Amapá ou fora dos estritos limites de pesquisa, devidamente aprovada pelo Comitê de Ética ;'),
                pw.Text(
                    '6.8 - Fornecer a senha de acesso ao Aplicativo VIDA a terceiros ou não observar a devida cautela na sua guarda e sigilo.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 7ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'O descumprimento do presente Termo, tendo sido previamente aceito, sujeitará o infrator às sanções na esfera administrativa, sem prejuízo de eventuais ações nas esferas civil e criminal, respondendo pela extensão dos danos direta ou indiretamente causados à Universidade Federal do Amapá, seu corpo discente ou docente, ou à comunidade atendida no Laboratório de Análises de Clínicas 2 / Unidade Básica de Saúde (UBS) da UNIFAP, inclusive por lucros cessantes, danos materiais e/ou morais, bem como violações ao estabelecido na Lei Geral de Proteção de Dados Pessoais (LGPD), mesmo que a divulgação das informações confidenciais ocorram após o fim do projeto de pesquisa ou o desligamento do pesquisador da Universidade Federal do Amapá, ou ainda, após a utilização do sistema.'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 8ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text('Ficam excluídas do presente termo as informações:'),
                pw.Text(
                    'a) que sejam de domínio público (Lei nº 9.610, de 19 de fevereiro de 1998- http://www.dominiopublico.gov.br);'),
                pw.Text(
                    'b) informações que venham a ser disponibilizadas para o público, de outra forma que não seja por meio de divulgação por parte dos pesquisadores e prestadores de serviços da Universidade Federal do Amapá;'),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 12.0),
                  child: pw.Text(
                    'Cláusula 9ª',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(
                    'As obrigações de confidencialidade contidas neste instrumento terão validade por prazo indeterminado, ficando os pesquisadores e demais prestadores de serviços adstritos aos seus termos mesmo após o término do Contrato.'),
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
                'Cláusula 10ª',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'No caso de dúvidas quanto ao correto procedimento a ser tomado para garantir o sigilo dos dados, deverá ser consultado o coordenador do projeto de pesquisa, ou a administração da Universidade Federal do Amapá.'),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Cláusula 11ª',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'A Universidade Federal do Amapá tem o direito de, a qualquer momento, modificar, alterar ou retirar quaisquer políticas ou procedimentos, adicionar outros que se façam necessários para o perfeito funcionamento do sistema, mediante simples aviso por circular.'),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                  'Por concordar com a redação supra e do inequívoco compromisso firmado, declaro ciência e concordância, aderindo a todos os termos e condições ora estabelecidos.'),
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
