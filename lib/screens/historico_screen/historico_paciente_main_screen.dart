import 'package:flutter/material.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/components/snippet_list.dart';
import 'package:vida_app/helpers/snippet_list_retriever_helper.dart';
import 'package:vida_app/models/paciente_model.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente.sexo == 'F' ? 'Histórico da paciente' : 'Histórico do paciente'),
      ),
      body: FutureBuilder<List<dynamic>>(
        initialData: [],
        future: SnippetListRetrieverHelper.retrieveSnippetList(widget.paciente),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('Ocorreu um erro desconhecido na aplicação.'),
              );

            case ConnectionState.waiting:
              return Progress(
                message: 'Carregando o histórico do paciente',
              );
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<dynamic> snippetList = snapshot.data as List<dynamic>;

                if (snippetList.isEmpty) {
                  return const Center(child: Text('Nenhum registro encontrado!'));
                }

                return SnippetList(snippetList);
              }

              return const Center(child: Text('Nenhum registro encontrado!'));

            default:
              return Center(
                child: Text('Ocorreu um erro desconhecido na aplicação.'),
              );
          }
        },
      ),
    );
  }
}
