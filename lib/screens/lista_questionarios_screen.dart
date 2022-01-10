import 'package:flutter/material.dart';
import 'package:vida_app/screens/questionario_ansiedade/questionario_ansiedade_screen.dart';

class ListaQuestionarios extends StatelessWidget {
  const ListaQuestionarios({Key? key}) : super(key: key);

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
                'Selecione o questionário a ser aplicado no(a) paciente.',
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
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuestionarioAnsiedade())),
            )),
            Card(
                child: ListTile(
              leading: Icon(
                Icons.list_alt_rounded,
              ),
              title: Text('Depressão'),
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
              title: Text('Dor'),
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
