import 'package:cloud_firestore/cloud_firestore.dart';

class Instituicao {
  static final String tableName = 'instituicao';

  static final String tableSQL = '''
    CREATE TABLE `$tableName`
      (
       `uuid_instituicao`    text NOT NULL ,
       `nome_instituicao`    text NOT NULL ,
       `id_tipo_instituicao` integer NOT NULL ,
      
      PRIMARY KEY (`uuid_instituicao`),
      FOREIGN KEY (`id_tipo_instituicao`) REFERENCES `tipo_instituicao_domain` (`id_tipo_instituicao`)
      );
  ''';

  static final String firestoreCollectionName = 'instituicoes';

  final String uuidInstituicao;
  String nomeInstituicao;
  int idTipoInstituicao;

  Instituicao(
      {required this.uuidInstituicao, required this.nomeInstituicao, required this.idTipoInstituicao});

  Instituicao.fromJson(Map<String, dynamic> json) :
      this(
        uuidInstituicao: json['uuidInstituicao'],
        nomeInstituicao: json['nomeInstituicao'],
        idTipoInstituicao: json['idTipoInstituicao'],
      );

  Map<String, dynamic> toJson() {
    return {
      'uuidInstituicao' : uuidInstituicao,
      'nomeInstituicao' : nomeInstituicao.toUpperCase(),
      'idTipoInstituicao' : idTipoInstituicao,
    };
  }

  Future<void> firestoreAdd() {
    CollectionReference instituicoes = FirebaseFirestore.instance.collection(firestoreCollectionName);

    return instituicoes.doc(uuidInstituicao).set(toJson());
  }

}