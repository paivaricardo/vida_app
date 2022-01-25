import 'package:flutter/material.dart';
import 'package:vida_app/components/title_text.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/intervencao_model.dart';
import 'package:vida_app/models/pic_model.dart';

class ResultadoIntervencaoScreen extends StatelessWidget {
  final Intervencao intervencao;

  const ResultadoIntervencaoScreen({required this.intervencao, Key? key})
      : super(key: key);

  // String uuidIntervencao;
  // DateTime dataRealizacao;
  // Pesquisador pesquisador;
  // Paciente paciente;
  // int idPic;
  // int duration;
  // String nomeAplicadorIntervencao;
  // String obsIntervencao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intervenção'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TitleText('Data da realização'),
              ),
              Text(DateTimeHelper.retrieveFormattedDateStringBR(
                  intervencao.dataRealizacao)),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Identificador'),
              ),
              Text(intervencao.uuidIntervencao),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Pesquisador responsável'),
              ),
              Text(intervencao.pesquisador.nomePesquisador),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Paciente'),
              ),
              Text(intervencao.paciente.nome),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('PICS aplicada'),
              ),
              Text(Pic.getPicValue(intervencao.idPic)),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Duração'),
              ),
              Text(intervencao.duration.toString()),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Nome do aplicador da intervenção'),
              ),
              Text(intervencao.nomeAplicadorIntervencao),
              const Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TitleText('Observações'),
              ),
              Text(intervencao.obsIntervencao),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text('Retornar'),
                      icon: Icon(Icons.arrow_back_rounded),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text('Editar'),
                      icon: Icon(Icons.edit),
                    ),
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
