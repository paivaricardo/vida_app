import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vida_app/components/title_text.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class TelaInclusaoPesquisador extends StatelessWidget {
  final String userEmail;
  final String userPassword;

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  TelaInclusaoPesquisador(this.userEmail, this.userPassword, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inclusão de pesquisador'), automaticallyImplyLeading: false,),
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
                child: Text('Informe ao pesquisador o e-mail e a senha acima para acesso ao sistema. Será enviado uma mensagem obrigatória de confirmação à caixa de endereço de e-mail informada. Além disso, no primeiro acesso, será necessário trocar a senha por outra.'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Esta tela será mostrada somente uma vez. Caso a senha seja perdida, será necessário executar a recuperação por meio da opção "Esqueceu a senha?".'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Após o fechamento desta tela, o usuário atual será desautenticado. Será necessário autenticar-se novamente.'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(onPressed: () async{
                  await _firebaseAuthService.firebaseSignOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, icon: Icon(Icons.close),label: Text('Fechar tela')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
