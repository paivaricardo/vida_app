import 'package:vida_app/models/paciente_model.dart';

class Questionario {
  static String tableName = 'questionario_aplicado';

  static final String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_questionario_aplicado`  text NOT NULL ,
       `data_aplicacao_questionario` text NOT NULL ,
       `pontuacao_questionario`      integer NULL ,
       `uuid_paciente`               text NOT NULL ,
       `id_questionario_domain`      integer NOT NULL ,
       `uuid_pesquisador`            text NULL ,
      
      PRIMARY KEY (`uuid_questionario_aplicado`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`),
      FOREIGN KEY (`uuid_pesquisador`) REFERENCES `pesquisador` (`uuid_pesquisador`),
      FOREIGN KEY (`id_questionario_domain`) REFERENCES `questionario_domain` (`id_questionario_domain`)
      );
  ''';

  String? uuidQuestionarioAplicado;
  DateTime? dataAplicacaoQuestionario;
  int idQuestionarioDomain;
  Paciente paciente;
  int pontuacaoQuestionario = 0;
  String? uuidPesquisador;

  Questionario({required this.idQuestionarioDomain, required this.paciente});

}
