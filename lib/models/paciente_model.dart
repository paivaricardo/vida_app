import 'dart:math';

class Paciente {
  static final String tableName = 'paciente';

  static final String tableSQL = '''
    CREATE TABLE `paciente`
      (
       `id_paciente`         INTEGER PRIMARY KEY AUTOINCREMENT,
       `nome`                varchar(140) NOT NULL ,
       `data_nascimento`     varchar(255) NOT NULL ,
       `id_sexo`             int NOT NULL ,
       `id_escolaridade`     int NOT NULL ,
       `profissao`           varchar(45) NOT NULL ,
       `peso`                decimal(5,2) NOT NULL ,
       `altura`              decimal(3,2) NOT NULL ,
       `conhece_pic`         boolean NOT NULL ,
       `apresenta_ansiedade` boolean NOT NULL ,
       `apresenta_depressao` boolean NOT NULL ,
       `apresenta_dor`       boolean NOT NULL ,
       `local_dor`           varchar(140) NOT NULL ,
       `fumante`             boolean NOT NULL ,
       `frequencia_fumo`     varchar(45) NOT NULL ,
       `cigarros_dia`        int NOT NULL ,
       `faz_uso_medicamento` boolean NOT NULL ,
       `medicamentos`        varchar(250) NOT NULL ,
      
        FOREIGN KEY (`id_escolaridade`) REFERENCES `escolaridade` (`id_escolaridade`),
        FOREIGN KEY (`id_sexo`) REFERENCES `sexo` (`id_sexo`)
      );
  ''';

  int? id;
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
      {this.id,
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
    return 'Paciente{nome: $nome, dataNascimento: $dataNascimento, sexo: $sexo, escolaridade: $escolaridade, profissao: $profissao, pesoAtual: $pesoAtual, altura: $altura, conhecePic: $conhecePic, quaisPicConhece: $quaisPicConhece, apresentaAnsiedade: $apresentaAnsiedade, apresentaDepressao: $apresentaDepressao, apresentaDor: $apresentaDor, localDor: $localDor, fumante: $fumante, frequenciaFumo: $frequenciaFumo, cigarrosDia: $cigarrosDia, fazUsoMedicamento: $fazUsoMedicamento, medicamento: $medicamentos}';
  }
}
