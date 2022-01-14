import 'package:flutter/material.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/screens/questionario_ansiedade/questionario_ansiedade_screen.dart';

class ListaQuestionarios extends StatelessWidget {
  final Paciente paciente;

  const ListaQuestionarios(this.paciente, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Aplicação de questionário'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 24.0),
              child: Text(
                paciente.sexo == 'F'
                ? 'Selecione o questionário a ser aplicado na paciente ${paciente.nome}.'
                : paciente.sexo == 'M'
                ? 'Selecione o questionário a ser aplicado no paciente ${paciente.nome}.'
                : 'Selecione o questionário a ser aplicado em paciente ${paciente.nome}.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
              ),
              title: Text('Ansiedade'),
              subtitle: Text('BAI (INVENTÁRIO DE ANSIEDADE DE BECK)'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionarioAnsiedadeScreen(paciente))),
            )),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
              ),
              title: Text('Depressão'),
              subtitle: Text('Patient Health Questionnaire-9 (PHQ-9)'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Funcionalidade a ser implentada futuramente.')));
              },
            )),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
              ),
              title: Text('Depressão'),
              subtitle: Text('ESCALA DE DEPRESSÃO DE BECK'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Funcionalidade a ser implentada futuramente.')));
              },
            )),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
              ),
              title: Text('Dor geral'),
              subtitle: Text('INVENTÁRIO BREVE DA DOR'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Funcionalidade a ser implentada futuramente.')));
              },
            )),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
              ),
              title: Text('Dor nas costas'),
              subtitle: Text('STarT Back Screening Tool- Brasil (SBST-Brasil)'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Funcionalidade a ser implentada futuramente.')));
              },
            )),
            Card(
                child: ListTile(
                  leading: Icon(
                    Icons.list_alt_rounded,
                  ),
                  title: Text('Tabagismo'),
                  subtitle: Text('TESTE DE FARGESTRÖM'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                        Text('Funcionalidade a ser implentada futuramente.')));
                  },
                )),
          ],
        )));
  }
}
