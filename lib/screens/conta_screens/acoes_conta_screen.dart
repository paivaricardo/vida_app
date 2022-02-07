import 'package:flutter/material.dart';
import 'package:vida_app/screens/conta_screens/alterar_senha_screen.dart';

class AcoesContaScreen extends StatelessWidget {
  const AcoesContaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ações para a conta'),
      ),
      body: Column(
        children: <Widget>[
          Card(
              child: ListTile(
            leading: Icon(
              Icons.settings_rounded,
            ),
            title: Text('Alterar senha'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlterarSenhaScreen()));
            },
          )),
          Card(
              child: ListTile(
            leading: Icon(
              Icons.settings_rounded,
            ),
            title: Text('Visualizar perfil'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Funcionalidade a ser implementada futuramente.'),
              ));
            },
          )),
        ],
      ),
    );
  }
}
