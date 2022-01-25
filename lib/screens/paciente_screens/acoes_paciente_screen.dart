import 'package:flutter/material.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/screens/historico_screen/historico_paciente_main_screen.dart';
import 'package:vida_app/screens/intervencao/registrar_intervencao_screen.dart';
import 'package:vida_app/screens/lista_questionarios_screen.dart';

class AcoesPacienteScreen extends StatelessWidget {
  final Paciente paciente;

  const AcoesPacienteScreen(this.paciente, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(paciente.sexo == 'F'
            ? 'Ações para a paciente'
            : paciente.sexo == 'M' ? 'Ações para o paciente' : 'Ações para paciente'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Paciente:', style: TextStyle(fontSize: 24.0),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(paciente.nome.toUpperCase(),  style: TextStyle(fontSize: 16.0),),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.list_alt_rounded),
                title: Text('Aplicar questionário'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListaQuestionarios(paciente)));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.favorite_rounded),
                title: Text('Registrar intervenção'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrarIntervencaoScreen(paciente: paciente)));
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.list_alt_rounded),
                title: Text('Visualizar histórico'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoricoPacienteMainScreen(paciente: paciente)));
                },
              ),
            ),            Card(
              child: ListTile(
                leading: Icon(Icons.list_alt_rounded),
                title: Text('Visualizar ficha cadastral'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                      Text('Funcionalidade a ser implentada futuramente.')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
