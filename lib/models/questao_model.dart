import 'package:vida_app/models/questao_questionario_domain_model.dart';
import 'package:vida_app/models/questionario_model.dart';

class Questao {
  static String tableName = 'questao_questionario_aplicada';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_questionario_aplicado`     text NOT NULL ,
       `id_questao_questionario_domain` integer NOT NULL ,
       `pontuacao_questao`              integer NULL ,
      
      PRIMARY KEY (`uuid_questionario_aplicado`, `id_questao_questionario_domain`),
      FOREIGN KEY (`id_questao_questionario_domain`) REFERENCES `questao_questionario_domain` (`id_questao_questionario_domain`),
      FOREIGN KEY (`uuid_questionario_aplicado`) REFERENCES `questionario_aplicado` (`uuid_questionario_aplicado`)
      );
  ''';

  Questionario questionario;
  int idQuestaoQuestionarioDomain;
  int pontuacao;
  int ordemQuestaoDomain;
  String descricao;

  Questao(this.questionario, this.ordemQuestaoDomain)
      : descricao = QuestaoQuestionarioDomain.findQuestaoDescription(
            questionario.idQuestionarioDomain, ordemQuestaoDomain),
        pontuacao = 0,
        idQuestaoQuestionarioDomain = questionario.idQuestionarioDomain + ordemQuestaoDomain;
}
