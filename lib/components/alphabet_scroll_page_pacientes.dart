import 'package:flutter/material.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/screens/paciente_screens/acoes_paciente_screen.dart';

class AlphabetScrollPagePacientes extends StatefulWidget {
  final List<Paciente> listPacientes;

  const AlphabetScrollPagePacientes({ required this.listPacientes, Key? key}) : super(key: key);

  @override
  _AlphabetScrollPagePacientesState createState() => _AlphabetScrollPagePacientesState();
}

class _AlphabetScrollPagePacientesState extends State<AlphabetScrollPagePacientes> {

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: widget.listPacientes.length,
      itemBuilder: (context, index) {
        final Paciente paciente = widget.listPacientes[index];

        return _PacienteCard(
          paciente: paciente,
          onClick: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AcoesPacienteScreen(paciente),));
          },
        );
      },
    );
  }

}

class _PacienteCard extends StatelessWidget {
  final Paciente paciente;
  final Function onClick;

  const _PacienteCard({ required this.paciente, required this.onClick, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        leading: Icon(Icons.person),
        title: Text(
          paciente.nome,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}


