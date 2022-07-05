import 'package:flutter/material.dart';
import 'package:vida_app/components/title_text.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/screens/paciente_screens/editar_paciente_screen.dart';

class VisualizarFichaCadastralScreen extends StatelessWidget {
  final Paciente paciente;

  const VisualizarFichaCadastralScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText('Visualizar ficha cadastral'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText('Nome completo'),
                SelectableText(paciente.nome),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Identificador'),
                ),
                SelectableText(paciente.uuid.toString()),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Data de nascimento'),
                ),
                SelectableText(DateTimeHelper.retrieveFormattedDateStringBR(
                    paciente.dataNascimento)),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Sexo'),
                ),
                () {
                  switch (paciente.sexo) {
                    case 'M':
                      return const SelectableText('Masculino');
                    case 'F':
                      return const SelectableText('Feminino');
                    case 'N':
                      return const SelectableText('Não binário');
                    default:
                      return const SelectableText('Outro');
                  }
                }(),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Escolaridade'),
                ),
                SelectableText(paciente.escolaridade),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Profissão'),
                ),
                SelectableText(paciente.profissao),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Peso atual'),
                ),
                SelectableText('${paciente.pesoAtual.toString()} kg'),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Altura'),
                ),
                SelectableText('${paciente.altura.toString()} m'),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('IMC'),
                ),
                () {
                  double imcCalculado = paciente.calculaIMC();
                  String interpretacaoIMC = '';

                  if (imcCalculado < 16.9) {
                    interpretacaoIMC = 'Muito abaixo do peso';
                  } else if (imcCalculado < 18.4) {
                    interpretacaoIMC = 'Abaixo do peso';
                  } else if (imcCalculado < 24.9) {
                    interpretacaoIMC = 'Peso normal';
                  } else if (imcCalculado < 29.9) {
                    interpretacaoIMC = 'Sobrepeso';
                  } else if (imcCalculado < 34.9) {
                    interpretacaoIMC = 'Obesidade Grau I';
                  } else if (imcCalculado < 40.0) {
                    interpretacaoIMC = 'Obesidade Grau II';
                  } else if (imcCalculado >= 40) {
                    interpretacaoIMC = 'Obesidade Grau III';
                  }

                  return SelectableText('$imcCalculado ($interpretacaoIMC) ');
                }(),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Conhece alguma PICS?'),
                ),
                SelectableText(paciente.conhecePic ? 'Sim' : 'Não'),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Visibility(
                    visible: paciente.conhecePic,
                    child: TitleText('Quais PICS conhece?'),
                  ),
                ),
                Visibility(
                  visible: paciente.conhecePic,
                  child: SelectableText(paciente.quaisPicConhece.keys
                      .where((key) => paciente.quaisPicConhece[key] == true)
                      .toList()
                      .toString()
                      .substring(
                          1,
                          paciente.quaisPicConhece.keys
                                  .where((key) =>
                                      paciente.quaisPicConhece[key] == true)
                                  .toList()
                                  .toString()
                                  .length -
                              1)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Apresenta algum desses problemas?'),
                ),
                Row(
                  children: [
                    SelectableText('Ansiedade: '),
                    SelectableText(paciente.apresentaAnsiedade ? 'Sim' : 'Não'),
                  ],
                ),
                Row(
                  children: [
                    SelectableText('Depressão: '),
                    SelectableText(paciente.apresentaDepressao ? 'Sim' : 'Não'),
                  ],
                ),
                Row(
                  children: [
                    SelectableText('Dores: '),
                    SelectableText(paciente.apresentaDor ? 'Sim' : 'Não'),
                  ],
                ),
                Visibility(
                  visible: paciente.apresentaDor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TitleText('Local da dor'),
                  ),
                ),
                Visibility(
                    visible: paciente.apresentaDor,
                    child: SelectableText(paciente.localDor)),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('É fumante?'),
                ),
                SelectableText(paciente.fumante ? 'Sim' : 'Não'),
                Visibility(
                  visible: paciente.fumante,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TitleText('Quantos cigarros por dia?'),
                  ),
                ),
                Visibility(
                    visible: paciente.fumante,
                    child: SelectableText(paciente.cigarrosDia.toString())),
                Visibility(
                  visible: paciente.fumante,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TitleText('Data de início do fumo'),
                  ),
                ),
                Visibility(
                    visible: paciente.fumante,
                    child: SelectableText(paciente.dataInicioFumo != null
                        ? DateTimeHelper.retrieveFormattedDateStringBR(
                            paciente.dataInicioFumo)
                        : 'Sem informação')),
                Visibility(
                  visible: paciente.fumante,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TitleText('Carga tabágica'),
                  ),
                ),
                Visibility(
                  visible: paciente.fumante,
                  child: SelectableText(paciente.calculaCargaTabagica() == -1
                      ? 'Sem informação'
                      : '${paciente.calculaCargaTabagica().toString()} anos-maço'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Faz uso de medicamento(s)?'),
                ),
                SelectableText(paciente.fazUsoMedicamento ? 'Sim' : 'Não'),
                Visibility(
                  visible: paciente.fazUsoMedicamento,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TitleText('Quais medicamentos faz uso?'),
                  ),
                ),
                Visibility(
                  visible: paciente.fazUsoMedicamento,
                  child: SelectableText(paciente.medicamentos.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Cartão SUS'),
                ),
                SelectableText(
                    paciente.cartaoSUS == null || paciente.cartaoSUS!.isEmpty
                        ? 'Sem informação'
                        : paciente.cartaoSUS!),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Observações'),
                ),
                SelectableText(paciente.observacoes ?? 'Sem observações.'),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TitleText('Data de registro'),
                ),
                SelectableText(paciente.dataRegistroPaciente != null
                    ? DateTimeHelper.retrieveFormattedDateStringBR(
                        paciente.dataRegistroPaciente)
                    : 'Sem informação.'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_rounded),
                      label: Text('Retornar'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditarPacienteScreen(
                                        paciente: paciente,
                                      )));
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Editar')),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
