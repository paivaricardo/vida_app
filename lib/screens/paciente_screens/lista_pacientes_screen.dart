import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/components/alphabet_scroll_page_pacientes.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/paciente_screens/cadastro_paciente_screen.dart';

class ListaPacientesScreen extends StatefulWidget {
  const ListaPacientesScreen({Key? key}) : super(key: key);

  @override
  State<ListaPacientesScreen> createState() => _ListaPacientesScreenState();
}

class _ListaPacientesScreenState extends State<ListaPacientesScreen> {
  Stream<QuerySnapshot> _getPacientesStream() {
    Pesquisador pesquisadorLogado = Provider.of<Pesquisador?>(context)!;

    switch (pesquisadorLogado.idPerfilUtilizador) {
      case 1:
        return FirebaseFirestore.instance
            .collection(Paciente.firestoreCollectionName)
            .orderBy('nome')
            .snapshots();
      default:
        return FirebaseFirestore.instance
            .collection(Paciente.firestoreCollectionName)
            .where('uuidPesquisadoresAutorizados',
                arrayContains: pesquisadorLogado.uuidPesquisador.toString())
            .orderBy('nome')
            .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de pacientes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _getPacientesStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um problema desconhecido.'));
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('Sem conexão :/'),
                );

              case ConnectionState.waiting:
                return const Progress(
                  message: 'Carregando dados de pacientes...',
                );

              case ConnectionState.active:
                if (snapshot.data != null) {
                  List<DocumentSnapshot> pacientesDocSnapshots =
                      snapshot.data!.docs;

                  if (pacientesDocSnapshots.isEmpty || pacientesDocSnapshots.contains(null)) {
                    return Center(
                      child: Text('Não há pacientes cadastrados ainda!'),
                    );
                  }

                  List<Paciente> pacientes = pacientesDocSnapshots
                      .map((element) => Paciente.fromJson(
                          element.data() as Map<String, dynamic>))
                      .toList();

                  return AlphabetScrollPagePacientes(listPacientes: pacientes);
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
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => CadastroPacienteScreen(),
              ))
              .then((value) => setState(() {}));
        },
        tooltip: 'Cadastrar novo paciente',
        child: Icon(Icons.add),
      ),
    );
  }
}
