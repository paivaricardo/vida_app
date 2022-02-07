import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vida_app/models/intervencao_model.dart';
import 'package:vida_app/models/questionario_ansiedade_model.dart';
import 'package:vida_app/models/questionario_depressao_beck_model.dart';
import 'package:vida_app/models/questionario_depressao_phq9_model.dart';
import 'package:vida_app/models/questionario_domain_model.dart';
import 'package:vida_app/models/questionario_dor_inventario_model.dart';
import 'package:vida_app/models/questionario_dor_start_model.dart';
import 'package:vida_app/models/questionario_tabagismo_fagerstrom_model.dart';

class HistoricoListRetrieverHelper {

  static List<dynamic> retrieveHistoricoList(List<DocumentSnapshot> listDocuments) {

    List<Map<String, dynamic>> historicoList = listDocuments.map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>).toList();

    List<dynamic> mappedHistoricoList = historicoList.map((element) {
      if(!element.containsKey('idQuestionarioDomain')) {
        return Intervencao.fromJson(element);

      } else {
        switch(element['idQuestionarioDomain']) {
          case QuestionarioDomain.ansiedadeBAIDomainValue:
            return QuestionarioAnsiedade.fromJson(element);
          case QuestionarioDomain.depressaoPHQ9DomainValue:
            return QuestionarioDepressaoPHQ9.fromJson(element);
          case QuestionarioDomain.depressaoBeckDomainValue:
            return QuestionarioDepressaoBeck.fromJson(element);
          case QuestionarioDomain.dorInventarioDomainValue:
            return QuestionarioDorInventario.fromJson(element);
          case QuestionarioDomain.dorStartDomainValue:
            return QuestionarioDorStart.fromJson(element);
          case QuestionarioDomain.tabagismoFagerstromDomainValue:
            return QuestionarioTabagismoFagerstrom.fromJson(element);
        }

      }
    }).toList();

    mappedHistoricoList.sort((a, b) => a.dataRealizacao.compareTo(b.dataRealizacao));

    return mappedHistoricoList;
  }

}