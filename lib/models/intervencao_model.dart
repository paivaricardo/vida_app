import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/pic_model.dart';
import 'package:vida_app/screens/intervencao/resultado_intervencao_screen.dart';

class Intervencao {
  static String tableName = 'intervencao';

  static String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_intervencao`                 text NOT NULL ,
       `data_realizacao`                  text NOT NULL ,
       `uuid_pesquisador`                 text NOT NULL ,
       `uuid_paciente`                    text NOT NULL ,
       `id_pic`                           integer NOT NULL ,
       `duration`                         integer NOT NULL ,
       `nome_aplicador_intervencao`       text NULL ,
       `obs_intervencao`                  text NOT NULL ,
      
      PRIMARY KEY (`uuid_intervencao`),
      FOREIGN KEY (`uuid_paciente`) REFERENCES `paciente` (`uuid_paciente`),
      FOREIGN KEY (`uuid_pesquisador`) REFERENCES `pesquisador` (`uuid_pesquisador`),
      FOREIGN KEY (`id_pic`) REFERENCES `pic` (`id_pic`)
      );
  ''';

  static const String firestoreCollectionName = 'intervencoes';

  String uuidIntervencao;
  DateTime dataRealizacao;
  Pesquisador pesquisador;
  Paciente paciente;
  int idPic;
  int duration;
  String nomeAplicadorIntervencao;
  String obsIntervencao;

  Intervencao(
      {required this.uuidIntervencao,
      required this.dataRealizacao,
      required this.pesquisador,
      required this.paciente,
      required this.idPic,
      required this.duration,
      required this.nomeAplicadorIntervencao,
      required this.obsIntervencao});

  Intervencao.fromJson(Map<String, dynamic> json)
      : this(
          uuidIntervencao: json['uuidIntervencao'],
          dataRealizacao: json['dataRealizacao'].toDate(),
          pesquisador: Pesquisador.fromJson(json['pesquisador']),
          paciente: Paciente.fromJson(json['paciente']),
          idPic: json['idPic'],
          duration: json['duration'],
          nomeAplicadorIntervencao: json['nomeAplicadorIntervencao'],
          obsIntervencao: json['obsIntervencao'],
        );

  Map<String, dynamic> toJson() {
    return {
      'uuidIntervencao': uuidIntervencao,
      'dataRealizacao': dataRealizacao,
      'pesquisador': pesquisador.toJson(),
      'paciente': paciente.toJson(),
      'idPic': idPic,
      'duration': duration,
      'nomeAplicadorIntervencao': nomeAplicadorIntervencao.toUpperCase(),
      'obsIntervencao': obsIntervencao.toUpperCase(),
    };
  }

  Future<void> firestoreAdd() {
    CollectionReference instituicoes =
        FirebaseFirestore.instance.collection(firestoreCollectionName);

    return instituicoes.doc(uuidIntervencao).set(toJson());
  }

  Widget buildSnippet(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ResultadoIntervencaoScreen(intervencao: this)));
          },
          child: SizedBox(
            height: 130,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite_rounded),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intervenção',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        Pic.getPicValue(
                            idPic),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'Duração: $duration min',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                          'Data: ${DateTimeHelper.retrieveFormattedDateStringBR(dataRealizacao)}'),
                      Text('Id.: $uuidIntervencao'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
