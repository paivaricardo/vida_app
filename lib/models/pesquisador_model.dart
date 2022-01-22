import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String uuidInstituicao;
  String cpfPesquisador;
  String cargoPesquisador;
  String emailPesquisador;
  int idPerfilUtilizador;
  int icActive;
  int icAuthorized;
  int firstAccess;

  // Optional relational parameters
  Instituicao? instituicaoInstance;

  Pesquisador(
      {required this.uuidPesquisador,
      required this.nomePesquisador,
      required this.uuidInstituicao,
      required this.cpfPesquisador,
      required this.cargoPesquisador,
      required this.emailPesquisador,
      required this.idPerfilUtilizador,
      this.icActive = 1,
      this.icAuthorized = 1,
      this.firstAccess = 1});

  Pesquisador.fromJson(Map<String, dynamic> json) :
      this(
        uuidPesquisador : json['uuidPesquisador'],
        nomePesquisador : json['nomePesquisador'],
        uuidInstituicao : json['uuidInstituicao'],
        cpfPesquisador : json['cpfPesquisador'],
        cargoPesquisador : json['cargoPesquisador'],
        emailPesquisador : json['emailPesquisador'],
        idPerfilUtilizador : int.parse(json['idPerfilUtilizador'].toString()),
        icActive : int.parse(json['icActive'].toString()),
        icAuthorized : int.parse(json['icAuthorized'].toString()),
        firstAccess : int.parse(json['firstAccess'].toString()),
      )
  ;

  static Future<Pesquisador?> getPesquisadorfromFirebaseAuthUser(User? user) async {

    if (user == null) {
      return null;
    }

     Pesquisador? pesquisador = await FirebaseFirestore.instance.collection(firestoreCollectionName).limit(1).where('emailPesquisador', isEqualTo: user.email).get().then((QuerySnapshot snapshot) => Pesquisador.fromJson(snapshot.docs[0].data() as Map<String, dynamic>));

    return pesquisador;

  }
  
  Map<String, dynamic> toJson() {
    return {
      'uuidPesquisador' : uuidPesquisador,
      'nomePesquisador' : nomePesquisador.toUpperCase(),
      'uuidInstituicao' : uuidInstituicao,
      'cpfPesquisador' : cpfPesquisador,
      'cargoPesquisador' : cargoPesquisador.toUpperCase(),
      'emailPesquisador' : emailPesquisador.toLowerCase(),
      'idPerfilUtilizador' : idPerfilUtilizador,
      'icActive' : icActive,
      'icAuthorized' : icAuthorized,
      'firstAccess' : firstAccess,
    };
  }

  Future<void> firestoreAdd() {

    CollectionReference pesquisadores = FirebaseFirestore.instance.collection(firestoreCollectionName);

    return pesquisadores.doc(uuidPesquisador).set(toJson());
  }

  Future<void> retrieveInstituicao() {
    CollectionReference instituicaoRef = FirebaseFirestore.instance.collection(Instituicao.firestoreCollectionName);

    return instituicaoRef.doc(uuidInstituicao).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        instituicaoInstance = Instituicao.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      }
    });

  }

  @override
  String toString() {
    return 'Pesquisador: {uuidPesquisador: $uuidPesquisador, nomePesquisador: $nomePesquisador, uuidInstituicao: $uuidInstituicao, cpfPesquisador: $cpfPesquisador, cargoPesquisador: $cargoPesquisador, emailPesquisador: $emailPesquisador, idPerfilUtilizador: $idPerfilUtilizador, icActive: $icActive, icAuthorized: $icAuthorized, firstAccess: $firstAccess, instituicaoInstance: $instituicaoInstance}';
  }
}
