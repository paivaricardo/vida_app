import 'package:flutter/material.dart';
import 'package:vida_app/components/alphabet_scroll_page_pacientes.dart';
import 'package:vida_app/components/progress.dart';
import 'package:vida_app/database/dao/paciente_dao.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/screens/paciente_screens/cadastro_paciente_screen.dart';

class ListaPacientesScreen extends StatefulWidget {
  const ListaPacientesScreen({Key? key}) : super(key: key);

  @override
  State<ListaPacientesScreen> createState() => _ListaPacientesScreenState();
}

class _ListaPacientesScreenState extends State<ListaPacientesScreen> {
  PacienteDAO _pacienteDAO = PacienteDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de pacientes'),
      ),
      body: FutureBuilder<List<Paciente>>(
        initialData: [],
        future: _pacienteDAO.findAllOrdered(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('Ocorreu um erro desconhecido na aplicação.'),
              );
            case ConnectionState.waiting:
              return Progress(
                message: 'Carregando dados de pacientes',
              );
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Paciente> pacientes =
                    snapshot.data as List<Paciente>;

                if (pacientes.isEmpty) {
                  return Center(
                    child: Text('Não há pacientes cadastrados ainda!'),
                  );
                }

                return AlphabetScrollPagePacientes(
                  listPacientes: pacientes,
                );
              }

              return Center(
                child: Text('Não há pacientes cadastrados ainda!'),
              );

            default:
              return Center(
                child: Text('Ocorreu um erro desconhecido na aplicação.'),
              );
          }
        },
      ),
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
