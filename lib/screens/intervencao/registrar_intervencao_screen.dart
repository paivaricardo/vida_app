import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/models/intervencao_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/models/pic_model.dart';
import 'package:vida_app/screens/intervencao/resultado_intervencao_screen.dart';

class RegistrarIntervencaoScreen extends StatefulWidget {
  final Paciente paciente;

  const RegistrarIntervencaoScreen({required this.paciente, Key? key})
      : super(key: key);

  @override
  _RegistrarIntervencaoScreenState createState() =>
      _RegistrarIntervencaoScreenState();
}

class _RegistrarIntervencaoScreenState
    extends State<RegistrarIntervencaoScreen> {

  // Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Uuid
  final String _uuidIntervencao = Uuid().v4();

  // Input fields
  TextEditingController _datetimeIntervencaoController =
  TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _obsIntervencaoController = TextEditingController();
  TextEditingController _nomeAplicadorIntervencaoController = TextEditingController();

  // Dropdown values
  String? _picValue = Pic.picsValues.values.toList()[0];
  int _idPic = 1;

  bool _registrarButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar intervenção'),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Data da intervenção',
                      hintText: 'ex.: 10/09/2021 - digite apenas números'),
                  controller: _datetimeIntervencaoController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [DateTimeHelper.dateMaskFormatter],
                  validator: (dataIntervencao) {
                    if (dataIntervencao != null &&
                        DateTimeHelper.regExpData.hasMatch(dataIntervencao)) {
                      if (DateTimeHelper.dateParse(dataIntervencao)
                          .isAfter(widget.paciente.dataNascimento) &&
                          DateTimeHelper.dateParse(dataIntervencao)
                              .isBefore(DateTime.now()) ||
                          DateTimeHelper.dateParse(dataIntervencao)
                              .isAtSameMomentAs(DateTime.now())) {
                        return null;
                      } else {
                        return 'A data deve estar entre o nascimento do paciente e hoje.';
                      }
                    } else if (dataIntervencao == null) {
                      return 'Obrigatório fornecer a data da intervenção.';
                    } else {
                      return 'Digite uma data válida.';
                    }
                  },
                ),
                Text('Qual foi a PICS aplicada?'),
                Container(
                  child: DropdownButton<String>(
                    value: _picValue,
                    icon: const Icon(Icons.arrow_downward_rounded),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _picValue = newValue!;
                        _idPic = Pic.getPicId(newValue);
                        print(_idPic);
                      });
                    },
                    items: Pic.picsValues.values.toList()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Duração (minutos)',
                    hintText: 'Ex.: 30 (digite apenas números)',
                  ),
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome do aplicador da intervenção',
                    hintText: 'Nome da pessoa que aplicou a intervenção no paciente',
                  ),
                  controller: _nomeAplicadorIntervencaoController,
                  keyboardType: TextInputType.text,
                  maxLength: 150,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Observações',
                    hintText: 'Observações acerca da intervenção, etc.',
                  ),
                  controller: _obsIntervencaoController,
                  keyboardType: TextInputType.text,
                  maxLength: 500,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel),
                          label: Text('Cancelar'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey)),
                        ),
                        _buildCadastrarButton(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCadastrarButton() {
    if (!_registrarButtonPressed) {
      return ElevatedButton.icon(
        onPressed: tryRegister,
        icon: Icon(Icons.save),
        label: Text('Registrar'),
      );
    } else {
      return ElevatedButton(
        child: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text('Processando...'),
          ],
        ),
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
        ),
      );
    }
  }

  void tryRegister() {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _registrarButtonPressed = true;
        });

        Intervencao createdIntervencao = Intervencao(
          uuidIntervencao: _uuidIntervencao,
          dataRealizacao: DateTimeHelper.dateParse(
              _datetimeIntervencaoController.text),
          pesquisador: Provider.of<Pesquisador?>(context, listen: false)!,
          paciente: widget.paciente,
          idPic: _idPic,
          duration: _durationController.text.isEmpty? 0 : int.parse(_durationController.text),
          nomeAplicadorIntervencao: _nomeAplicadorIntervencaoController.text.isEmpty ? 'SEM INFORMAÇÃO' : _nomeAplicadorIntervencaoController.text,
          obsIntervencao: _obsIntervencaoController.text.isEmpty ? 'SEM OBSERVAÇÕES' : _obsIntervencaoController.text,);

        createdIntervencao.firestoreAdd();

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResultadoIntervencaoScreen(intervencao: createdIntervencao)));

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Intervenção registrada com sucesso!')));
      } catch (e) {
        print(e);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Houve um erro desconhecido ao registrar a intervenção: $e')));
      } finally {
        setState(() {
          _registrarButtonPressed = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Campos com dados inválidos ou faltando. Por favor, corrija e tente novamente.')));
    }
  }

}
