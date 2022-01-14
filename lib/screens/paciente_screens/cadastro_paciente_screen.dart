import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/database/dao/paciente_conhece_pics_dao.dart';
import 'package:vida_app/database/dao/paciente_dao.dart';
import 'package:vida_app/models/paciente_model.dart';

class CadastroPacienteScreen extends StatefulWidget {
  const CadastroPacienteScreen({Key? key}) : super(key: key);

  @override
  _CadastroPacienteScreenState createState() => _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen>
    with InputValidationMixin {
  // Uuid do paciente
  var generatedUuid = Uuid().v4();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // DAOs
  final PacienteDAO _pacienteDAO = PacienteDAO();
  final PacienteConhecePicsDAO _pacienteConhecePicsDAO =
      PacienteConhecePicsDAO();

  // Member variables
  String? radioValueSexo = 'M';
  bool fumante = false;
  bool fazUsoMedicamento = false;
  bool conhecePic = false;

  // Pics conhecidas
  bool conheceReflexologiaPodal = false;
  bool conheceAromaterapia = false;
  bool conheceAuriculoTerapia = false;
  bool conheceCromoterapia = false;

  // Problemas apresentados
  bool apresentaAnsiedade = false;
  bool apresentaDepressao = false;
  bool apresentaDores = false;

  // Dropdown options
  List<String> listaEscolaridade = [
    'Fundamental - Incompleto',
    'Fundamental - Completo',
    'Médio - Incompleto',
    'Médio - Completo',
    'Superior - Incompleto',
    'Superior - Completo',
    'Pós-graduação (Lato senso) - Incompleto',
    'Pós-graduação (Lato senso) - Completo',
    'Pós-graduação (Stricto sensu, nível mestrado) - Incompleto',
    'Pós-graduação (Stricto sensu, nível mestrado) - Completo',
    'Pós-graduação (Stricto sensu, nível doutor) - Incompleto',
    'Pós-graduação (Stricto sensu, nível doutor) - Completo',
    'Ignorado'
  ];
  List<String> listaFrequenciaFumo = [
    'Esporadicamente',
    'Frequentemente',
    'Sempre'
  ];

  // Dropdown variables
  String? escolaridade = 'Fundamental - Incompleto';
  String? frequenciaFumo = 'Esporadicamente';

  // Controllers
  final _controllerNome = TextEditingController();
  final _controllerProfissao = TextEditingController();
  final _controllerPesoAtual = TextEditingController();
  final _controllerAltura = TextEditingController();

  // Controllers data de nascimento
  final _controllerDiaNascimento = TextEditingController();
  final _controllerMesNascimento = TextEditingController();
  final _controllerAnoNascimento = TextEditingController();

  // Hidden controllers
  final _controllerLocalDor = TextEditingController();
  final _controllerCigarrosDia = TextEditingController();
  final _controllerMedicamento = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de paciente'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: _formUI(),
          ),
        ),
      ),
    );
  }

  Widget _formUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Nome completo',
          ),
          maxLength: 140,
          validator: constructValidator(validarNome, 'Digite um nome'),
          controller: _controllerNome,
        ),
        Text('Data de nascimento'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Dia',
                ),
                maxLength: 2,
                validator: constructValidator(validarDiaNascimento, '??'),
                controller: _controllerDiaNascimento,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mês',
                ),
                maxLength: 2,
                validator: constructValidator(validarMesNascimento, '??'),
                controller: _controllerMesNascimento,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 100,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ano',
                ),
                maxLength: 4,
                validator: constructValidator(validarAnoNascimento, '????'),
                controller: _controllerAnoNascimento,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        Text('Sexo'),
        IntrinsicHeight(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 600,
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(2.0),
                      title: Text('Masculino'),
                      leading: Radio(
                        value: 'M',
                        groupValue: radioValueSexo,
                        onChanged: (String? value) {
                          setState(() {
                            radioValueSexo = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(2.0),
                      title: Text('Feminino'),
                      leading: Radio(
                        value: 'F',
                        groupValue: radioValueSexo,
                        onChanged: (String? value) {
                          print(value);

                          setState(() {
                            radioValueSexo = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(2.0),
                      title: Text('Não binário(a)'),
                      leading: Radio(
                        value: 'N',
                        groupValue: radioValueSexo,
                        onChanged: (String? value) {
                          print(value);

                          setState(() {
                            radioValueSexo = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(2.0),
                      title: Text('Outro'),
                      leading: Radio(
                        value: 'O',
                        groupValue: radioValueSexo,
                        onChanged: (String? value) {
                          print(value);

                          setState(() {
                            radioValueSexo = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text('Escolaridade'),
        Container(
          width: 300,
          child: DropdownButton<String>(
            value: escolaridade,
            isExpanded: true,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                escolaridade = newValue!;
              });
            },
            items:
                listaEscolaridade.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Profissão'),
          maxLength: 140,
          controller: _controllerProfissao,
          validator:
              constructValidator(notNullValidator, 'Digite uma profissão.'),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Peso atual (kg)',
            suffix: Text('kg'),
          ),
          maxLength: 6,
          controller: _controllerPesoAtual,
          keyboardType: TextInputType.number,
          validator:
              constructValidator(validarPeso, 'Digite um peso válido (kg).'),
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Altura (m)',
            suffix: Text('m'),
          ),
          maxLength: 4,
          controller: _controllerAltura,
          keyboardType: TextInputType.number,
          validator: constructValidator(
              validarAltura, 'Digite uma altura válida (m).'),
        ),
        Row(
          children: [
            Text('Conhece alguma PIC?'),
            Checkbox(
                value: conhecePic,
                onChanged: (bool? value) {
                  setState(() {
                    conhecePic = value!;
                    conheceReflexologiaPodal = false;
                    conheceAromaterapia = false;
                    conheceAuriculoTerapia = false;
                    conheceCromoterapia = false;
                  });
                }),
          ],
        ),
        Visibility(
          visible: conhecePic,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Qual(is) PIC(s) conhece (selecione)?'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Reflexologia podal'),
                    contentPadding: EdgeInsets.only(left: -3.0),
                    leading: Checkbox(
                        value: conheceReflexologiaPodal,
                        onChanged: (bool? value) {
                          setState(() {
                            conheceReflexologiaPodal = value!;
                          });
                        }),
                  ),
                  ListTile(
                    title: Text('Aromaterapia'),
                    contentPadding: EdgeInsets.only(left: -3.0),
                    leading: Checkbox(
                        value: conheceAromaterapia,
                        onChanged: (bool? value) {
                          setState(() {
                            conheceAromaterapia = value!;
                          });
                        }),
                  ),
                  ListTile(
                    title: Text('Auriculoterapia '),
                    contentPadding: EdgeInsets.only(left: -3.0),
                    leading: Checkbox(
                        value: conheceAuriculoTerapia,
                        onChanged: (bool? value) {
                          setState(() {
                            conheceAuriculoTerapia = value!;
                          });
                        }),
                  ),
                  ListTile(
                    title: Text('Cromoterapia'),
                    contentPadding: EdgeInsets.only(left: -3.0),
                    leading: Checkbox(
                        value: conheceCromoterapia,
                        onChanged: (bool? value) {
                          setState(() {
                            conheceCromoterapia = value!;
                          });
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Text('Apresenta algum desses problemas?'),
        ),
        ListTile(
          title: Text('Ansiedade'),
          contentPadding: EdgeInsets.only(left: -3.0),
          leading: Checkbox(
              value: apresentaAnsiedade,
              onChanged: (bool? value) {
                setState(() {
                  apresentaAnsiedade = value!;
                });
              }),
        ),
        ListTile(
          title: Text('Depressão'),
          contentPadding: EdgeInsets.only(left: -3.0),
          leading: Checkbox(
              value: apresentaDepressao,
              onChanged: (bool? value) {
                setState(() {
                  apresentaDepressao = value!;
                });
              }),
        ),
        ListTile(
          title: Text('Dores'),
          contentPadding: EdgeInsets.only(left: -3.0),
          leading: Checkbox(
              value: apresentaDores,
              onChanged: (bool? value) {
                setState(() {
                  apresentaDores = value!;
                  _controllerLocalDor.clear();
                });
              }),
        ),
        Visibility(
          visible: apresentaDores,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Local da dor'),
            maxLength: 140,
            controller: _controllerLocalDor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Row(
            children: [
              Text('É fumante?'),
              Checkbox(
                  value: fumante,
                  onChanged: (bool? value) {
                    setState(() {
                      fumante = value!;
                      _controllerCigarrosDia.clear();
                    });
                  }),
            ],
          ),
        ),
        Visibility(
          visible: fumante,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Com que frequência fuma (selecione)?'),
              Container(
                child: DropdownButton<String>(
                  value: frequenciaFumo,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      frequenciaFumo = newValue!;
                    });
                  },
                  items: listaFrequenciaFumo
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Quantos cigarros por dia?'),
                maxLength: 2,
                controller: _controllerCigarrosDia,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text('Faz uso de medicamento(s)?'),
            Checkbox(
                value: fazUsoMedicamento,
                onChanged: (bool? value) {
                  setState(() {
                    fazUsoMedicamento = value!;
                    _controllerMedicamento.clear();
                  });
                }),
          ],
        ),
        Visibility(
          visible: fazUsoMedicamento,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Qual(is) medicamento(s)?'),
            maxLength: 250,
            controller: _controllerMedicamento,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        Paciente pacienteCreated = Paciente(
                          uuid: generatedUuid,
                          nome: _controllerNome.text.toUpperCase(),
                          dataNascimento: DateTime(
                            int.parse(_controllerAnoNascimento.text),
                            int.parse(_controllerMesNascimento.text),
                            int.parse(_controllerDiaNascimento.text),
                          ),
                          sexo: radioValueSexo!,
                          escolaridade: escolaridade!,
                          profissao: _controllerProfissao.text,
                          pesoAtual: double.parse(_controllerPesoAtual.text),
                          altura: double.parse(_controllerAltura.text),
                          conhecePic: conhecePic,
                          quaisPicConhece: {
                            'Reflexologia podal': conheceReflexologiaPodal,
                            'Aromaterapia': conheceAromaterapia,
                            'Auriculoterapia': conheceAuriculoTerapia,
                            'Cromoterapia': conheceCromoterapia,
                          },
                          apresentaAnsiedade: apresentaAnsiedade,
                          apresentaDepressao: apresentaDepressao,
                          apresentaDor: apresentaDores,
                          localDor: _controllerLocalDor.text.isEmpty
                              ? 'Sem dor'
                              : _controllerLocalDor.text,
                          fumante: fumante,
                          frequenciaFumo:
                              fumante ? frequenciaFumo! : 'Não fumante',
                          cigarrosDia: int.parse(
                              _controllerCigarrosDia.text.isEmpty || !fumante
                                  ? '0'
                                  : _controllerCigarrosDia.text),
                          fazUsoMedicamento: fazUsoMedicamento,
                          medicamentos: _controllerMedicamento.text.isEmpty
                              ? fazUsoMedicamento
                                  ? 'Não informado'
                                  : 'Nenhum'
                              : _controllerMedicamento.text,
                        );

                        await _pacienteDAO
                            .save(pacienteCreated)
                            .timeout(Duration(seconds: 5), onTimeout: () {
                          throw TimeoutException(
                              'Tempo limite excedido para cadastro de paciente');
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Paciente cadastrado com sucesso!')));

                        Navigator.pop(context);
                      } catch (error) {
                        debugPrint(error.toString());

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Houve um erro desconhecido ao cadastrar o paciente.')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Alguns campos foram preenchidos com dados inválidos ou faltantes. Verifique os campos e tente o cadastro novamente.')));
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text('Cadastrar')),
            ],
          ),
        )
      ],
    );
  }
}

mixin InputValidationMixin {
  String? Function(String?) constructValidator(
      Function validador, String? returnMessage) {
    return (param) {
      if (validador(param)) {
        return null;
      } else {
        return returnMessage;
      }
    };
  }

  bool validarNome(String? nome) => (nome != null &&
      nome.isNotEmpty &&
      RegExp(r'[a-zA-Z][a-zA-Z\s]+[a-zA-Z]').hasMatch(nome));

  bool validarDiaNascimento(String? dia) => (dia != null &&
      dia.isNotEmpty &&
      int.parse(dia) > 0 &&
      int.parse(dia) <= 31.0);

  bool validarMesNascimento(String? mes) => (mes != null &&
      mes.isNotEmpty &&
      int.parse(mes) > 0 &&
      int.parse(mes) <= 12.0);

  bool validarAnoNascimento(String? ano) => (ano != null &&
      ano.isNotEmpty &&
      int.parse(ano) > 1910 &&
      int.parse(ano) <= DateTime.now().year);

  bool notNullValidator(String? param) => (param != null && param.isNotEmpty);

  bool validarPeso(String? peso) => (peso != null &&
      peso.isNotEmpty &&
      double.parse(peso) > 0 &&
      double.parse(peso) < 300.0);

  bool validarAltura(String? altura) => (altura != null &&
      altura.isNotEmpty &&
      double.parse(altura) > 0.3 &&
      double.parse(altura) < 3.0);
}
