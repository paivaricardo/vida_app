import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vida_app/models/instituicao_model.dart';

class Pesquisador {
  static Pesquisador? loggedInPesquisador;

  static const String tableName = 'pesquisador';

  static const String tableSQL = '''
    CREATE TABLE `pesquisador`
      (
       `uuid_pesquisador`     text NOT NULL ,
       `nome_pesquisador`     text NOT NULL ,
       `uuid_instituicao`     text NOT NULL ,
       `cpf_pesquisador`      text NOT NULL ,
       `cargo_pesquisador`    text NOT NULL ,
       `email_pesquisador`    text NOT NULL ,
       `id_perfil_utilizador` integer NOT NULL ,
       `ic_active`            integer NOT NULL ,
       `ic_authorized`        integer NOT NULL ,
      
      PRIMARY KEY (`uuid_pesquisador`),
      FOREIGN KEY (`id_perfil_utilizador`) REFERENCES `perfil_utilizador_domain` (`id_perfil_utilizador`),
      FOREIGN KEY (`uuid_instituicao`) REFERENCES `instituicao` (`uuid_instituicao`)
      );
  ''';

  static const String firestoreCollectionName = 'pesquisadores';

  final String uuidPesquisador;
  String nomePesquisador;
  Instituicao instituicao;
  String cpfPesquisador;
  String cargoPesquisador;
  String emailPesquisador;
  int idPerfilUtilizador;
  bool icActive;
  bool icAuthorized;
  bool firstAccess;

  // Optional relational parameters

  Pesquisador(
      {required this.uuidPesquisador,
      required this.nomePesquisador,
      required this.instituicao,
      required this.cpfPesquisador,
      required this.cargoPesquisador,
      required this.emailPesquisador,
      required this.idPerfilUtilizador,
      this.icActive = true,
      this.icAuthorized = true,
      this.firstAccess = true,
      });

  Pesquisador.fromJson(Map<String, dynamic> json)
      : this(
          uuidPesquisador: json['uuidPesquisador'],
          nomePesquisador: json['nomePesquisador'],
          instituicao: Instituicao.fromJson(json['instituicao']),
          cpfPesquisador: json['cpfPesquisador'],
          cargoPesquisador: json['cargoPesquisador'],
          emailPesquisador: json['emailPesquisador'],
          idPerfilUtilizador: int.parse(json['idPerfilUtilizador'].toString()),
          icActive: json['icActive'],
          icAuthorized: json['icAuthorized'],
          firstAccess: json['firstAccess'],
        );

  static Future<Pesquisador?> getPesquisadorfromFirebaseAuthUser(
      User? user) async {
    if (user == null) {
      return null;
    }

    Pesquisador? pesquisador = await FirebaseFirestore.instance
        .collection(firestoreCollectionName)
        .limit(1)
        .where('emailPesquisador', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot snapshot) => Pesquisador.fromJson(
            snapshot.docs[0].data() as Map<String, dynamic>));

    return pesquisador;
  }

  Map<String, dynamic> toJson() {
    return {
      'uuidPesquisador': uuidPesquisador,
      'nomePesquisador': nomePesquisador.toUpperCase(),
      'instituicao' : instituicao.toJson(),
      'cpfPesquisador': cpfPesquisador,
      'cargoPesquisador': cargoPesquisador.toUpperCase(),
      'emailPesquisador': emailPesquisador.toLowerCase(),
      'idPerfilUtilizador': idPerfilUtilizador,
      'icActive': icActive,
      'icAuthorized': icAuthorized,
      'firstAccess': firstAccess,
    };
  }

  Future<void> firestoreAdd() {
    CollectionReference pesquisadores =
        FirebaseFirestore.instance.collection(firestoreCollectionName);

    return pesquisadores.doc(uuidPesquisador).set(toJson());
  }

  Future<void> updateFirstAccess() {
    DocumentReference pesquisadorDocRef = FirebaseFirestore.instance.collection(firestoreCollectionName).doc(uuidPesquisador);

    return pesquisadorDocRef.update(
        { 'firstAccess' : false });
  }

  @override
  String toString() {
    return 'Pesquisador{uuidPesquisador: $uuidPesquisador, nomePesquisador: $nomePesquisador, instituicao: $instituicao, cpfPesquisador: $cpfPesquisador, cargoPesquisador: $cargoPesquisador, emailPesquisador: $emailPesquisador, idPerfilUtilizador: $idPerfilUtilizador, icActive: $icActive, icAuthorized: $icAuthorized, firstAccess: $firstAccess}';
  }

// Não mais usado - objeto instituição está dentro do documento do pesquisador
// Future<void> retrieveInstituicao() {
  //   CollectionReference instituicaoRef = FirebaseFirestore.instance
  //       .collection(Instituicao.firestoreCollectionName);
  //
  //   return instituicaoRef
  //       .doc(uuidInstituicao)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       instituicao = Instituicao.fromJson(
  //           documentSnapshot.data() as Map<String, dynamic>);
  //     }
  //   });
  // }


}
