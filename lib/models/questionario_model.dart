import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/helpers/questionario_redirect_helper.dart';
import 'package:vida_app/models/paciente_model.dart';
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
       `ic_active`                   integer DEFAULT 1 ,
      
      PRIMARY KEY (`uuid_questionario_aplicado`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`),
      FOREIGN KEY (`uuid_pesquisador`) REFERENCES `pesquisador` (`uuid_pesquisador`),
      FOREIGN KEY (`id_questionario_domain`) REFERENCES `questionario_domain` (`id_questionario_domain`)
      );
  ''';

  String? uuidQuestionarioAplicado;
  DateTime? dataRealizacao;
  int idQuestionarioDomain;
  Paciente paciente;
  int pontuacaoQuestionario = 0;
  String? uuidPesquisador;

  Questionario({required this.idQuestionarioDomain, required this.paciente});

  Questionario.buildFromQuestionario(Questionario questionario) :
        uuidQuestionarioAplicado = questionario.uuidQuestionarioAplicado,
        dataRealizacao = questionario.dataRealizacao,
        idQuestionarioDomain = questionario.idQuestionarioDomain,
        paciente = questionario.paciente,
        pontuacaoQuestionario = questionario.pontuacaoQuestionario,
        uuidPesquisador = questionario.uuidPesquisador;

  Widget buildSnippet(BuildContext context) {
    return InkWell(
      child: Card(
        child: SizedBox(
          height: 130,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.list_alt_rounded),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Questionário',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      QuestionarioDomain.retriveNomeQuestionario(
                          idQuestionarioDomain)[0],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      QuestionarioDomain.retriveNomeQuestionario(
                          idQuestionarioDomain)[1],
                      style: TextStyle(color: Colors.grey),
                    ),
                    Visibility(visible: QuestionarioDomain.visibleScores[idQuestionarioDomain]!,child: Text('Score: ${pontuacaoQuestionario}', style: TextStyle(fontSize: 16.0, color: Colors.deepOrange),)),
                    Text(
                        'Data: ${DateTimeHelper.retriedFormattedDateStringBR(dataRealizacao)}'),
                    Text('Id.: ${uuidQuestionarioAplicado}'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () async => await QuestionarioRedirectHelper.redirectQuestionario(this, context),
    );
  }
}
