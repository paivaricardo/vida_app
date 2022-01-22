import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vida_app/components/progress.dart';
import 'package:vida_app/models/instituicao_model.dart';
import 'package:vida_app/models/tipo_instituicao_model.dart';
import 'package:vida_app/screens/instituicoes/cadastrar_instituicao_screen.dart';
import 'package:vida_app/screens/instituicoes/consultar_instituicao_screen.dart';

class SelecionarInstituicaoScreen extends StatefulWidget {
  const SelecionarInstituicaoScreen({Key? key}) : super(key: key);

  @override
  _SelecionarInstituicaoScreenState createState() => _SelecionarInstituicaoScreenState();
}

class _SelecionarInstituicaoScreenState extends State<SelecionarInstituicaoScreen> {
  final Stream<QuerySnapshot> _instituicoesStream =

  FirebaseFirestore.instance.collection('instituicoes').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar instituição'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _instituicoesStream,
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
                  message: 'Carregando dados de instituições',
                );

              case ConnectionState.active:
                if (snapshot.data != null) {
                  List<DocumentSnapshot> instituicoesDocSnapshots = snapshot.data!.docs;

                  if (instituicoesDocSnapshots.isEmpty) {
                    return Center(
                      child: Text('Não há instituições cadastradas ainda!'),
                    );
                  }

                  List<Instituicao> instituicoes = instituicoesDocSnapshots.map((element) => Instituicao.fromJson(element.data() as Map<String, dynamic>)).toList();

                  return ListView.builder(
                      itemCount: instituicoes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.home),
                            title: Text(instituicoes[index].nomeInstituicao),
                            subtitle: Text(
                                TipoInstituicao.getTipoInstituicaoValue(
                                    instituicoes[index].idTipoInstituicao)),
                            onTap: () {
                              Navigator.pop(context, instituicoes[index]);
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CadastrarInstituicaoScreen()));
        },
      ),
    );
  }
}
