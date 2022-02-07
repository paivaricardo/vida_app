import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class VisualizarPesquisadoresScreen extends StatefulWidget {
  final Paciente paciente;

  const VisualizarPesquisadoresScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _VisualizarPesquisadoresScreenState createState() =>
      _VisualizarPesquisadoresScreenState();
}

class _VisualizarPesquisadoresScreenState
    extends State<VisualizarPesquisadoresScreen> {
  Stream<QuerySnapshot> _streamPesquisadores() {
    Stream<QuerySnapshot> _streamPesquisadoresAutorizadoFirestore =
        FirebaseFirestore.instance
            .collection(Pesquisador.firestoreCollectionName)
            .snapshots();

    return _streamPesquisadoresAutorizadoFirestore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autorizar pesquisador'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamPesquisadores(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('Sem conexão :/'),
                );

              case ConnectionState.waiting:
                return const Progress(
                  message: 'Carregando histórico...',
                );

              case ConnectionState.active:
                if (snapshot.data != null) {
                  List<Pesquisador> pesquisadores =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> pesquisadorData =
                        document.data() as Map<String, dynamic>;

                    return Pesquisador.fromJson(pesquisadorData);
                  }).toList();

                  List<Pesquisador> pesquisadoresNaoAutorizados = pesquisadores
                      .where((pesquisador) => !widget
                          .paciente.uuidPesquisadoresAutorizados!
                          .contains(pesquisador.uuidPesquisador) && pesquisador.idPerfilUtilizador != 1)
                      .toList();

                  if (pesquisadoresNaoAutorizados.isEmpty) {
                    return Center(
                        child: Text('Nenhum pesquisador encontrado!'));
                  } else {
                    return ListView.builder(
                        itemCount: pesquisadoresNaoAutorizados.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.smart_toy_rounded),
                              title: Text(pesquisadoresNaoAutorizados[index]
                                  .nomePesquisador),
                              onTap: () {
                                Navigator.pop(context,
                                    pesquisadoresNaoAutorizados[index]);
                              },
                            ),
                          );
                        });
                  }
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
          },
        ),
      ),
    );
  }
}
