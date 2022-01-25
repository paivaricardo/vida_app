import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';

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
       `observacoes`                 text NULL ,
       `ic_active`                   integer DEFAULT 1 ,
      
      PRIMARY KEY (`uuid_questionario_aplicado`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`),
      FOREIGN KEY (`uuid_pesquisador`) REFERENCES `pesquisador` (`uuid_pesquisador`),
      FOREIGN KEY (`id_questionario_domain`) REFERENCES `questionario_domain` (`id_questionario_domain`)
      );
  ''';

  static const String firestoreCollectionName = 'questionarios';

  String? uuidQuestionarioAplicado;
  DateTime? dataRealizacao;
  int idQuestionarioDomain;
  Paciente paciente;
  int pontuacaoQuestionario = 0;
  String interpretacaoPontuacaoQuestionario = '';
  Pesquisador? pesquisadorResponsavel;
  String observacoes = 'SEM OBSERVAÇÕES';
  int icActive = 1;

  Questionario({
    this.uuidQuestionarioAplicado,
    this.dataRealizacao,
    required this.idQuestionarioDomain,
    required this.paciente,
    this.pontuacaoQuestionario = 0,
    this.interpretacaoPontuacaoQuestionario = '',
    this.pesquisadorResponsavel,
    this.observacoes = 'SEM OBSERVAÇÕES',
    this.icActive = 1,
  });

  Questionario.buildMinimal(
      {required this.idQuestionarioDomain, required this.paciente});

  Questionario.buildFromQuestionario(Questionario questionario)
      : uuidQuestionarioAplicado = questionario.uuidQuestionarioAplicado,
        dataRealizacao = questionario.dataRealizacao,
        idQuestionarioDomain = questionario.idQuestionarioDomain,
        paciente = questionario.paciente,
        pontuacaoQuestionario = questionario.pontuacaoQuestionario,
        interpretacaoPontuacaoQuestionario =
            questionario.interpretacaoPontuacaoQuestionario,
        pesquisadorResponsavel = questionario.pesquisadorResponsavel,
        observacoes = questionario.observacoes;
}
