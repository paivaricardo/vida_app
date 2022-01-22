import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vida_app/components/title_text.dart';

class TelaInclusaoPesquisador extends StatelessWidget {
  final String userEmail;
  final String userPassword;

  const TelaInclusaoPesquisador(this.userEmail, this.userPassword, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inclusão de pesquisador')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TitleText('Pesquisador incluído com sucesso na base de dados.'),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('E-mail:'),
              ),
              SelectableText(userEmail, style: TextStyle(fontSize: 24.0),),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Senha:'),
              ),
                  SelectableText(userPassword, style: TextStyle(fontSize: 24.0, color: Colors.deepOrange),),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Informe ao pesquisador o e-mail e a senha acima para acesso ao sistema. No primeiro acesso, será necessário trocar a senha por outra.'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Esta tela será mostrada somente uma vez. Caso a senha seja perdida, será necessário executar a recuperação por meio da opção "Esqueceu a senha?".'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close),label: Text('Fechar tela')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
