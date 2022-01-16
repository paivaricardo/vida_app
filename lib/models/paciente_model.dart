import 'dart:math';

class Paciente {
  static final String tableName = 'paciente';

  static final String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_paciente`       text NOT NULL ,
       `nome`                text NOT NULL ,
       `data_nascimento`     text NOT NULL ,
       `id_escolaridade`     integer NOT NULL ,
       `id_sexo`             integer NOT NULL ,
       `profissao`           text NOT NULL ,
       `altura`              real NOT NULL ,
       `peso`                real NOT NULL ,
       `conhece_pic`         text NOT NULL ,
       `apresenta_ansiedade` text NOT NULL ,
       `apresenta_depressao` text NOT NULL ,
       `apresenta_dor`       text NOT NULL ,
       `local_dor`           text NOT NULL ,
       `fumante`             text NOT NULL ,
       `frequencia_fumo`     text NOT NULL ,
       `cigarros_dia`        integer NOT NULL ,
       `faz_uso_medicamento` text NOT NULL ,
       `medicamentos`        text NOT NULL ,
       `ic_active`           integer DEFAULT 1 ,
      
      PRIMARY KEY (`uuid_paciente`),
      FOREIGN KEY (`id_escolaridade`) REFERENCES `escolaridade` (`id_escolaridade`),
      FOREIGN KEY (`id_sexo`) REFERENCES `sexo` (`id_sexo`)
      );
  ''';

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

  Paciente(
      {this.uuid,
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
      required this.medicamentos});

  double calculaIMC() {
    return altura / pow(pesoAtual, 2);
  }

  @override
  String toString() {
    return 'Paciente{uuid: $uuid, nome: $nome, dataNascimento: $dataNascimento, sexo: $sexo, escolaridade: $escolaridade, profissao: $profissao, pesoAtual: $pesoAtual, altura: $altura, conhecePic: $conhecePic, quaisPicConhece: $quaisPicConhece, apresentaAnsiedade: $apresentaAnsiedade, apresentaDepressao: $apresentaDepressao, apresentaDor: $apresentaDor, localDor: $localDor, fumante: $fumante, frequenciaFumo: $frequenciaFumo, cigarrosDia: $cigarrosDia, fazUsoMedicamento: $fazUsoMedicamento, medicamentos: $medicamentos}';
  }
}
