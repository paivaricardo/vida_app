import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/helpers/historico_list_retriever_helper.dart';
import 'package:vida_app/models/intervencao_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';

class HistoricoPacienteMainScreen extends StatefulWidget {
  final Paciente paciente;

  const HistoricoPacienteMainScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _HistoricoPacienteMainScreenState createState() =>
      _HistoricoPacienteMainScreenState();
}

class _HistoricoPacienteMainScreenState
    extends State<HistoricoPacienteMainScreen> {

  // Partial solution - AsyncMap
  // Stream<List<DocumentSnapshot>> getMergedStreamAsyncMap() {
  //   final Stream<QuerySnapshot> _intervencoesStream = FirebaseFirestore.instance.collection(Intervencao.firestoreCollectionName).where('paciente.uuid', isEqualTo: widget.paciente.uuid).snapshots();
  //   final Future<QuerySnapshot> _questionarioQuery = FirebaseFirestore.instance.collection(Questionario.firestoreCollectionName).where('paciente.uuid', isEqualTo: widget.paciente.uuid).get();
  //
  //   final Stream<List<DocumentSnapshot>> _mergedStream = _intervencoesStream.asyncMap((QuerySnapshot intervencoesQuerySnapshot) async {
  //
  //     List<DocumentSnapshot> mergedDocuments = intervencoesQuerySnapshot.docs;
  //     List<DocumentSnapshot> documentsQuestionarios = await _questionarioQuery.then((QuerySnapshot questionariosQuerySnapshot) => questionariosQuerySnapshot.docs);
  //
  //     mergedDocuments.addAll(documentsQuestionarios);
  //
  //     return mergedDocuments;
  //
  //   });
  //
  //   return _mergedStream;
  //
  // }

  // Good solution, but the one below, with the list of QuerySnapshot, is cleaner.
  // Stream<List<DocumentSnapshot>> getMergedStreamDocsSnapsRxDart() {
  //   final Stream<QuerySnapshot> _intervencaoStream = FirebaseFirestore.instance.collection(Intervencao.firestoreCollectionName).where('paciente.uuid', isEqualTo: widget.paciente.uuid).snapshots();
  //   final Stream<QuerySnapshot> _questionariosStream = FirebaseFirestore.instance.collection(Questionario.firestoreCollectionName).where('paciente.uuid', isEqualTo: widget.paciente.uuid).snapshots();
  //
  //   final Stream<List<DocumentSnapshot>> _combinedStreams = CombineLatestStream.combine2(_intervencaoStream, _questionariosStream, (QuerySnapshot intervencaoStream, QuerySnapshot questionariosStream) => <DocumentSnapshot>[...intervencaoStream.docs, ...questionariosStream.docs]);
  //
  //   return _combinedStreams;
  // }

  Stream<List<QuerySnapshot>> getMergedStreamRxDart() {
    final Stream<QuerySnapshot> _intervencaoStream = FirebaseFirestore.instance.collection(Intervencao.firestoreCollectionName).where('paciente.uuid', isEqualTo: widget.paciente.uuid).snapshots();
    final Stream<QuerySnapshot> _questionariosStream = FirebaseFirestore.instance.collection(Questionario.firestoreCollectionName).where('paciente.uuid', isEqualTo: widget.paciente.uuid).snapshots();

    final Stream<List<QuerySnapshot>> _combinedStreams = CombineLatestStream.combine2(_intervencaoStream, _questionariosStream, (QuerySnapshot intervencaoStream, QuerySnapshot questionariosStream) => <QuerySnapshot>[intervencaoStream, questionariosStream]);

    return _combinedStreams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente.sexo == 'F' ? 'Histórico da paciente' : 'Histórico do paciente'),
      ),
      body: StreamBuilder<List<QuerySnapshot>>(
        stream: getMergedStreamRxDart(),
        builder: (BuildContext context,  AsyncSnapshot<List<QuerySnapshot>> snapshots) {
          if (snapshots.hasError) {
            return Text('Ocorreu um problema desconhecido. $snapshots.error');
          }

          switch (snapshots.connectionState) {
            case ConnectionState.none:
              return const Center(
                child: Text('Sem conexão :/'),
              );

            case ConnectionState.waiting:
              return const Progress(
                message: 'Carregando histórico...',
              );

            case ConnectionState.active:
              if (snapshots.data != null) {
                List<DocumentSnapshot> docSnapshotsInvervencao =
                    snapshots.data![0].docs;
                List<DocumentSnapshot> docSnapshotsQuestionarios =
                    snapshots.data![1].docs;

                List<DocumentSnapshot> docSnapshotsMergedList = [...docSnapshotsInvervencao, ...docSnapshotsQuestionarios];

                if (docSnapshotsMergedList.isEmpty) {
                  return Center(
                    child: Text('Nenhum registro encontrado!'),
                  );
                }

                List<dynamic> listElements = HistoricoListRetrieverHelper.retrieveHistoricoList(docSnapshotsMergedList);

                // Here is where the main view is located.
                return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: listElements.length,
                    itemBuilder: (context, index) {
                      return listElements[index].buildSnippet(context);
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
        },
      ),
    );
  }
}