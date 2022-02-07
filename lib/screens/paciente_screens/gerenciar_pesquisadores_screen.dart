import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/paciente_screens/visualizar_pesquisadores_screen.dart';

class PesquisadoresAutorizadosScreen extends StatefulWidget {
  final Paciente paciente;

  const PesquisadoresAutorizadosScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _PesquisadoresAutorizadosScreenState createState() =>
      _PesquisadoresAutorizadosScreenState();
}

class _PesquisadoresAutorizadosScreenState
    extends State<PesquisadoresAutorizadosScreen> {
  Stream<QuerySnapshot> _streamPesquisadoresAutorizados() {
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
        title: Text('Pesquisadores autorizados'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamPesquisadoresAutorizados(),
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

                  Pesquisador currentLoggedInPesquisador =
                      Provider.of<Pesquisador?>(context)!;

                  List<Pesquisador> pesquisadoresAutorizados = pesquisadores
                      .where((pesquisador) =>
                          widget.paciente.uuidPesquisadoresAutorizados!
                              .contains(pesquisador.uuidPesquisador) &&
                          pesquisador.uuidPesquisador !=
                              currentLoggedInPesquisador.uuidPesquisador && pesquisador.idPerfilUtilizador != 1)
                      .toList();

                  if (pesquisadoresAutorizados.isEmpty) {
                    return Center(
                        child:
                            Text('Nenhum pesquisador adicional autorizado.'));
                  } else {
                    return ListView.builder(
                        itemCount: pesquisadoresAutorizados.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.smart_toy_rounded),
                              title: Text(pesquisadoresAutorizados[index]
                                  .nomePesquisador),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: () async {
                                  widget.paciente.uuidPesquisadoresAutorizados
                                      ?.remove(pesquisadoresAutorizados[index]
                                          .uuidPesquisador);

                                  String requestResponse = await widget.paciente
                                      .updatePesquisadoresAutorizados();

                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Pesquisador desautorizado.')));
                                  });
                                },
                              ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Pesquisador? pesquisadorAdicionado = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VisualizarPesquisadoresScreen(
                      paciente: widget.paciente)));

          if (pesquisadorAdicionado != null) {
            widget.paciente.uuidPesquisadoresAutorizados!
                .add(pesquisadorAdicionado.uuidPesquisador);

            String requestResponse =
                await widget.paciente.updatePesquisadoresAutorizados();

            if (requestResponse == 'Success') {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Pesquisador autorizado com sucesso!')));
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Falha em sua requisição.')));
            }
          }
        },
      ),
    );
  }
}
