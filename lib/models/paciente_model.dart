import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class Paciente {
  static final String tableName = 'paciente';

  static final String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_paciente`                        text NOT NULL ,
       `nome`                                 text NOT NULL ,
       `data_nascimento`                      text NOT NULL ,
       `id_escolaridade`                      integer NOT NULL ,
       `id_sexo`                              integer NOT NULL ,
       `profissao`                            text NOT NULL ,
       `altura`                               real NOT NULL ,
       `peso`                                 real NOT NULL ,
       `conhece_pic`                          text NOT NULL ,
       `apresenta_ansiedade`                  text NOT NULL ,
       `apresenta_depressao`                  text NOT NULL ,
       `apresenta_dor`                        text NOT NULL ,
       `local_dor`                            text NOT NULL ,
       `fumante`                              text NOT NULL ,
       `frequencia_fumo`                      text NOT NULL ,
       `cigarros_dia`                         integer NOT NULL ,
       `faz_uso_medicamento`                  text NOT NULL ,
       `medicamentos`                         text NOT NULL ,
       `ic_active`                            integer DEFAULT 1 ,
       `ic_accepted_data_treatment`           integer DEFAULT 1 ,
       `pesquisadores_autorizados`            text NULL ,
      
      PRIMARY KEY (`uuid_paciente`),
      FOREIGN KEY (`id_escolaridade`) REFERENCES `escolaridade` (`id_escolaridade`),
      FOREIGN KEY (`id_sexo`) REFERENCES `sexo` (`id_sexo`)
      );
  ''';

  static const String firestoreCollectionName = 'pacientes';

  String? uuid;
  String nome;
  DateTime dataNascimento;
  String sexo;
  String escolaridade;
  String profissao;
  double pesoAtual;
  double altura;
  bool conhecePic;
  Map<String, bool> quaisPicConhece;
  bool apresentaAnsiedade;
  bool apresentaDepressao;
  bool apresentaDor;
  String localDor;
  bool fumante;
  String frequenciaFumo;
  int cigarrosDia;
  bool fazUsoMedicamento;
  String medicamentos;
  bool icActive;
  bool icAcceptedDataTreatment;
  List<String?>? uuidPesquisadoresAutorizados;

  Paciente({
    this.uuid,
    required this.nome,
    required this.dataNascimento,
    required this.sexo,
    required this.escolaridade,
    required this.profissao,
    required this.pesoAtual,
    required this.altura,
    required this.conhecePic,
    required this.quaisPicConhece,
    required this.apresentaAnsiedade,
    required this.apresentaDepressao,
    required this.apresentaDor,
    required this.localDor,
    required this.fumante,
    required this.frequenciaFumo,
    required this.cigarrosDia,
    required this.fazUsoMedicamento,
    required this.medicamentos,
    this.icActive = true,
    this.icAcceptedDataTreatment = true,
    this.uuidPesquisadoresAutorizados,
  });

  Paciente.fromJson(Map<String, dynamic> json)
      : this(
          uuid: json['uuid'],
          nome: json['nome'],
          dataNascimento: json['dataNascimento'].toDate(),
          sexo: json['sexo'],
          escolaridade: json['escolaridade'],
          profissao: json['profissao'],
          pesoAtual: json['pesoAtual'],
          altura: json['altura'],
          conhecePic: json['conhecePic'],
          quaisPicConhece: Map<String, bool>.from(json['quaisPicConhece']),
          apresentaAnsiedade: json['apresentaAnsiedade'],
          apresentaDepressao: json['apresentaDepressao'],
          apresentaDor: json['apresentaDor'],
          localDor: json['localDor'],
          fumante: json['fumante'],
          frequenciaFumo: json['frequenciaFumo'],
          cigarrosDia: json['cigarrosDia'],
          fazUsoMedicamento: json['fazUsoMedicamento'],
          medicamentos: json['medicamentos'],
          icActive: json['icActive'],
          icAcceptedDataTreatment: json['icAcceptedDataTreatment'],
          uuidPesquisadoresAutorizados: List<String>.from(json['uuidPesquisadoresAutorizados']),
        );

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'nome': nome.toUpperCase(),
      'dataNascimento': dataNascimento,
      'sexo': sexo,
      'escolaridade': escolaridade,
      'profissao': profissao.toUpperCase(),
      'pesoAtual': pesoAtual,
      'altura': altura,
      'conhecePic': conhecePic,
      'quaisPicConhece': quaisPicConhece,
      'apresentaAnsiedade': apresentaAnsiedade,
      'apresentaDepressao': apresentaDepressao,
      'apresentaDor': apresentaDor,
      'localDor': localDor.toUpperCase(),
      'fumante': fumante,
      'frequenciaFumo': frequenciaFumo,
      'cigarrosDia': cigarrosDia,
      'fazUsoMedicamento': fazUsoMedicamento,
      'medicamentos': medicamentos.toUpperCase(),
      'icActive': icActive,
      'icAcceptedDataTreatment': icAcceptedDataTreatment,
      'uuidPesquisadoresAutorizados': uuidPesquisadoresAutorizados,
    };
  }

  Future<void> firestoreAdd() {
    CollectionReference pacientes =
        FirebaseFirestore.instance.collection(firestoreCollectionName);

    return pacientes.doc(uuid).set(toJson());
  }

  double calculaIMC() {
    return altura / pow(pesoAtual, 2);
  }

  @override
  String toString() {
    return 'Paciente{uuid: $uuid, nome: $nome, dataNascimento: $dataNascimento, sexo: $sexo, escolaridade: $escolaridade, profissao: $profissao, pesoAtual: $pesoAtual, altura: $altura, conhecePic: $conhecePic, quaisPicConhece: $quaisPicConhece, apresentaAnsiedade: $apresentaAnsiedade, apresentaDepressao: $apresentaDepressao, apresentaDor: $apresentaDor, localDor: $localDor, fumante: $fumante, frequenciaFumo: $frequenciaFumo, cigarrosDia: $cigarrosDia, fazUsoMedicamento: $fazUsoMedicamento, medicamentos: $medicamentos, icActive: $icActive, icAcceptedDataTreatment: $icAcceptedDataTreatment, uuidPesquisadoresAutorizados: $uuidPesquisadoresAutorizados}';
  }
}
