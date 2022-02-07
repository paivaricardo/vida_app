import 'package:flutter/material.dart';
import 'package:vida_app/components/title_text.dart';
import 'package:vida_app/models/perfil_utilizador_domain.dart';
import 'package:vida_app/models/pesquisador_model.dart';

class ConsultarPesquisadorScreen extends StatelessWidget {
  Pesquisador pesquisador;

  ConsultarPesquisadorScreen({required this.pesquisador, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultar pesquisador'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Nome do pesquisador'),
              ),
              Text(pesquisador.nomePesquisador),
              const Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TitleText('Identificador do pesquisador'),
              ),
              Text(pesquisador.uuidPesquisador),
              const Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TitleText('Instituição'),
              ),
              Text(pesquisador.instituicao.nomeInstituicao),
              const Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TitleText('CPF'),
              ),
              Text(pesquisador.cpfPesquisador),
              const Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TitleText('Cargo'),
              ),
              Text(pesquisador.cargoPesquisador),
              const Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TitleText('E-mail'),
              ),
              Text(pesquisador.emailPesquisador),
              const Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TitleText('Tipo de perfil'),
              ),
              Text(PerfilUtilizador.getPerfilUtilizadorValue(pesquisador.idPerfilUtilizador)),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(onPressed: () {
                      Navigator.pop(context);
                    }, label: Text('Retornar'),
                      icon: Icon(Icons.arrow_back_rounded),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                    ),

                    // TODO: implementar a funcionada de edição
                    // ElevatedButton.icon(onPressed: () {
                    //   Navigator.pop(context);
                    // }, label: Text('Editar'),
                    //   icon: Icon(Icons.edit),
                    // ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
