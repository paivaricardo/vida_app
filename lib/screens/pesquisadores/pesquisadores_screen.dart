import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/pesquisadores/consultar_pesquisador_screen.dart';
import 'package:vida_app/screens/pesquisadores/cadastrar_pesquisador_screen.dart';

class PesquisadoresScreen extends StatefulWidget {
  const PesquisadoresScreen({Key? key}) : super(key: key);

  @override
  _PesquisadoresScreenState createState() => _PesquisadoresScreenState();
}

class _PesquisadoresScreenState extends State<PesquisadoresScreen> {
  final Stream<QuerySnapshot> _pesquisadoresStream = FirebaseFirestore.instance
      .collection(Pesquisador.firestoreCollectionName)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisadores'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _pesquisadoresStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Ocorreu um problema desconhecido.');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('Ocorreu um problema desconhecido.'),
                );

              case ConnectionState.waiting:
                return const Progress(
                  message: 'Carregando dados de pesquisadores',
                );

              case ConnectionState.active:
                if (snapshot.data != null) {
                  List<DocumentSnapshot> pesquisadoresDocSnapshots =
                      snapshot.data!.docs;

                  if (pesquisadoresDocSnapshots.isEmpty) {
                    return Center(
                      child: Text('Não há pesquisadores cadastrados ainda!'),
                    );
                  }

                  List<Pesquisador> pesquisadores = pesquisadoresDocSnapshots
                      .map((element) => Pesquisador.fromJson(
                          element.data() as Map<String, dynamic>))
                      .toList();

                  // pesquisadores.forEach((pesquisador) => pesquisador.retrieveInstituicao());

                  // Não mais usado - objeto instituição está dentro do documento do pesquisador
                  // Future.forEach(
                  //     pesquisadores,
                  //     (Pesquisador pesquisador) =>
                  //         pesquisador.retrieveInstituicao());

                  return ListView.builder(
                      itemCount: pesquisadores.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.home),
                            title: Text(pesquisadores[index].nomePesquisador),
                            subtitle:
                                Text(pesquisadores[index].cargoPesquisador),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ConsultarPesquisadorScreen(
                                        pesquisador: pesquisadores[index],
                                      )));
                            },
                          ),
                        );
                      });
                }

                return const Center(
                  child: Text('Ocorreu um problema desconhecido.'),
                );

              case ConnectionState.done:
                return const Center(
                  child: Text('Ocorreu um problema. Conexão fechada.'),
                );

              default:
                return const Center(
                  child: Text('Ocorreu um problema desconhecido.'),
                );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CadastrarPesquisadorScreen()));
        },
      ),
    );
  }
}
