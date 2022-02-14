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
                  'Este termo visa o registro do consentimento livre, informado e inequívoco pela qual o usuário concorda com o tratamento de seus dados pessoais e dados pessoais sensíveis referentes à saúde para finalidades específicas de pesquisa, em cumprimento às disposições da Lei nº 13.709/2018 - Lei Geral de Proteção de Dados Pessoais (LGPD).'),
            ),
            pw.Text(
                'Ao aceitar o presente termo, o usuário consente e concorda que a Universidade Federal do Amapá (UNIFAP) Instituição de Educação Superior (IES) localizada na Rodovia Josmar Chaves Pinto, km 02 - Jardim Marco Zero, CEP nº 68.903-419, Curso de Farmácia - Laboratório de Análises de clínicas 2, no município de Macapá, no estado do Amapá, mantida pela Fundação Universidade Federal do Amapá, pessoa jurídica de direito público - Federal, inscrita no Cadastro Nacional da Pessoa Jurídica (CNPJ) sob o nº 34.868.257/0001-81, endereço de e-mail madson@unifap.br, com sede no mesmo endereço da mantida, doravante denominada Controlador, tome decisões referentes ao tratamento de seus dados pessoais, bem como realize o tratamento de seus dados pessoais e dados pessoais sensíveis de saúde, envolvendo operações como as que se referem a coleta, produção, recepção, classificação, utilização, acesso, reprodução, transmissão, distribuição, processamento, arquivamento, armazenamento, eliminação, avaliação ou controle da informação, modificação, comunicação, transferência, difusão ou extração.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Dados pessoais e dados pessoais sensíveis',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador fica autorizado a tomar decisões referentes ao tratamento e a realizar o tratamento dos seguintes dados pessoais do Titular:'),
            pw.Text('- Nome completo'),
            pw.Text('- Data de nascimento'),
            pw.Text('- Sexo'),
            pw.Text('- Escolaridade'),
            pw.Text('- Profissão'),
            pw.Text('- Peso atual'),
            pw.Text('- Altura'),
            pw.Text(
                '- Conhecimento de Práticas Integrativas e Complementares em Saúde'),
            pw.Text(
                '- Questões de saúde específicas: ansiedade, depressão, dor e tabagismo/cessação tabágica'),
            pw.Text(
                '- Dados sobre a intensidade, frequência e início do tabagismo/cessação tabágica'),
            pw.Text(
                '- Dados sobre uso de medicamentos e quais medicamentos faz uso'),
            pw.Text(
                '- Dados complementares de saúde julgados necessário para fins de pesquisa e tratamento com Práticas Integrativas e Complementares em Saúde'),
            pw.Text(
                '- Resultados e pontuações alcançadas em questionários sobre ansiedade, depressão, dores e tabagismo/cessação tabágica, assim como apontamentos julgados necessários no momento da aplicação desses questionários'),
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
                '- Possibilitar que o Controlador identifique o titular e levante dados para a condução de pesquisas sobre a aplicação de Práticas Integrativas e Complementares em Saúde (PICS) e seus efeitos sobre a saúde, em especial sobre ansiedade, depressão e tabagismo/cessação tabágica, condições cujos níveis serão mensurados por meio de aplicação de questionários sobre o Titular, durante atendimentos a serem realizados na unidade básica de saúde da Universidade Federal do Amapá (UNIFAP) ou no Laboratório de Análises Clínicas 2 (LAC-2) do Curso de Farmácia da UNIFAP.'),
            pw.Text(
                '- Possibilitar que o Controlador possa realizar estatísticas e levantamento de dados anonimizados e análises de tendência e regressão linear, para a finalidade exclusiva e pesquisa sobre o impacto da aplicação de Práticas Integrativas e Complementares em Saúde (PICS).'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Compartilhamento de Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador não compartilhará os dados pessoais do Titular com outros agentes de tratamento de dados, exceto caso isso seja indispensável ao cumprimento das finalidades listadas neste termo, com o propósito exclusivo de pesquisa, excluídas finalidades comerciais, observados os princípios e as garantias estabelecidas pela Lei nº 13.709/2018.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Segurança dos Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador responsabiliza-se pela manutenção de medidas mínimas de segurança, que estejam ao seu alcance e capacidade técnica, aptas a proteger os dados pessoais de acessos não autorizados e de situações acidentais ou ilícitas de destruição, perda, alteração, comunicação ou qualquer forma de tratamento inadequado ou ilícito.'),
            pw.Text(
                'Em conformidade ao art. 48 da Lei nº 13.709/2018, o Controlador comunicará ao Titular e à Autoridade Nacional de Proteção de Dados (ANPD) a ocorrência de incidente de segurança que possa acarretar risco ou dano relevante ao Titular.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Término do Tratamento dos Dados',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Controlador poderá manter e tratar os dados pessoais do Titular durante todo o período em que os mesmos forem pertinentes ao alcance das finalidades listadas neste termo. Dados pessoais anonimizados, sem possibilidade de associação ao indivíduo, poderão ser mantidos por período indefinido.'),
            pw.Text(
                'O Titular poderá solicitar via e-mail ou mensagem ao Controlador, a qualquer momento, que sejam eliminados os dados pessoais não anonimizados do Titular.'),
            pw.Padding(
              padding: pw.EdgeInsets.only(top: 12.0),
              child: pw.Text(
                'Direitos do Titular',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Text(
                'O Titular tem direito a obter do Controlador, em relação aos dados por ele tratados, a qualquer momento e mediante requisição: I - confirmação da existência de tratamento; II - acesso aos dados; III - correção de dados incompletos, inexatos ou desatualizados; IV - anonimização, bloqueio ou eliminação de dados desnecessários, excessivos ou tratados em desconformidade com o disposto na Lei nº 13.709/2018; V - portabilidade dos dados a outro fornecedor de serviço ou produto, mediante requisição expressa, de acordo com a regulamentação da autoridade nacional, observados os segredos comercial e industrial; VI - eliminação dos dados pessoais tratados com o consentimento do titular, exceto nas hipóteses previstas no art. 16 da Lei nº 13.709/2018; VII - informação das entidades públicas e privadas com as quais o controlador realizou uso compartilhado de dados; VIII - informação sobre a possibilidade de não fornecer consentimento e sobre as consequências da negativa; IX - revogação do consentimento, nos termos do § 5º do art. 8º da Lei nº 13.709/2018.'),
          ];
        }));

    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text(
              'Direito de Revogação do Consentimento',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
                'Este consentimento poderá ser revogado pelo usuário, a qualquer momento, mediante solicitação via e-mail ou mensagem ao Controlador.'),
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
              child: pw.Text('Pesquisador responsável pelo cadastro:',
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
