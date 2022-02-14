import 'package:flutter/material.dart';
import 'package:vida_app/components/title_text.dart';
import 'package:vida_app/models/instituicao_model.dart';
import 'package:vida_app/models/tipo_instituicao_domain_model.dart';

class ConsultarInstituicaoScreen extends StatelessWidget {
  final Instituicao instituicao;

  const ConsultarInstituicaoScreen({required this.instituicao, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultar instituição')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TitleText('Nome da instituição'),
              ),
              Text(instituicao.nomeInstituicao),
              const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: TitleText('Tipo de instituição'),
              ),
              Text(TipoInstiuicaoDomain.getTipoInstituicaoValue(instituicao.idTipoInstituicao)),
              const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: TitleText('Identificador'),
              ),
              Text(instituicao.uuidInstituicao),
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

                    // TODO: implementar a funcionalidade de edição
                    // ElevatedButton.icon(onPressed: () {
                    //   Navigator.pop(context);
                    // }, label: Text('Editar'),
                    // icon: Icon(Icons.edit),
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
