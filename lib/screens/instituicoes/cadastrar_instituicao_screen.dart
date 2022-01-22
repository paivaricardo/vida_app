import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/models/instituicao_model.dart';
import 'package:vida_app/models/tipo_instituicao_domain_model.dart';

class CadastrarInstituicaoScreen extends StatefulWidget {
  const CadastrarInstituicaoScreen({Key? key}) : super(key: key);

  @override
  State<CadastrarInstituicaoScreen> createState() =>
      _CadastrarInstituicaoScreenState();
}

class _CadastrarInstituicaoScreenState
    extends State<CadastrarInstituicaoScreen> {
  // Instituição Uuid
  final String generatedUuid = Uuid().v4();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  TextEditingController _controllerNomeInstituicao = TextEditingController();

  // DropdownButton values
  String? _dropdownTipoInstituicaoValue = 'Instituição de Ensino Superior';
  int? _dropdownTipoInstituicaoId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar instituição')),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome da instituição',
                ),
                maxLength: 140,
                controller: _controllerNomeInstituicao,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text('Tipo de instituição'),
              ),
              DropdownButton(
                value: _dropdownTipoInstituicaoValue,
                isExpanded: true,
                icon: const Icon(Icons.arrow_downward_rounded),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownTipoInstituicaoValue = newValue!;
                    _dropdownTipoInstituicaoId =
                        TipoInstiuicaoDomain.getTipoInstituicaoId(
                            _dropdownTipoInstituicaoValue!);
                  });
                },
                items: TipoInstiuicaoDomain.tipoInstituicaoValues.values
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
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
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          try {
                            Instituicao createdInstituicao = Instituicao(
                                uuidInstituicao: generatedUuid,
                                nomeInstituicao:
                                _controllerNomeInstituicao.text,
                                idTipoInstituicao: _dropdownTipoInstituicaoId!);

                            createdInstituicao.firestoreAdd();

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Instituição cadastrada com sucesso!')));
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Houve um erro ao cadastrar a instituição: $e')));
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(Icons.save),
                        label: Text('Cadastrar'),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
