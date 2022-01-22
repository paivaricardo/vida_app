import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import 'package:vida_app/components/title_text.dart';
import 'package:vida_app/helpers/cpf_validation_helper.dart';
import 'package:vida_app/helpers/custom_exceptions.dart';
import 'package:vida_app/helpers/password_generate.dart';
import 'package:vida_app/models/instituicao_model.dart';
import 'package:vida_app/models/perfil_utilizador_domain.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/instituicoes/selecionar_instituicao_screen.dart';
import 'package:vida_app/screens/pesquisadores/tela_inclusao_pesquisador.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class CadastrarPesquisadorScreen extends StatefulWidget {
  const CadastrarPesquisadorScreen({Key? key}) : super(key: key);

  @override
  State<CadastrarPesquisadorScreen> createState() =>
      _CadastrarPesquisadorScreenState();
}

class _CadastrarPesquisadorScreenState extends State<CadastrarPesquisadorScreen>
    with InputValidatitonMixin {
  // Pesquisador Uuid
  final String generatedUuid = Uuid().v4();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  TextEditingController _controllerNomePesquisador = TextEditingController();
  TextEditingController _controllerCpfPesquisador = TextEditingController();
  TextEditingController _controllerCargoPesquisador = TextEditingController();
  TextEditingController _controllerEmailPesquisador = TextEditingController();

  // Instituicao
  Instituicao? selectedInstituicao;

  // DropdownButton values
  String? _dropdownPerfilUtilizadorValue = 'Mestrando';
  int _dropdownPerfilUtilizadorId = 2;

  // Mask - máscara de CPF
  MaskTextInputFormatter maskCPFFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  // Varíavel que controla se o botão foi pressionado
  bool _cadastrarButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar pesquisador')),
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
                    labelText: 'Nome',
                  ),
                  maxLength: 150,
                  validator:
                      constructValidator(validarNome, 'Digite um nome válido.'),
                  controller: _controllerNomePesquisador,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CPF',
                  ),
                  maxLength: 14,
                  controller: _controllerCpfPesquisador,
                  validator: constructValidator(
                      ValidarCPFHelper.validarCPF, 'Digite um CPF válido.'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskCPFFormatter],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TitleText('Instituicão'),
                ),
                Text(selectedInstituicao == null
                    ? 'Nenhuma instituição selecionada.'
                    : selectedInstituicao!.nomeInstituicao),
                Visibility(
                    visible: selectedInstituicao == null,
                    child: Text(
                      'Por favor, selecioe uma instituição.',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.deepOrange),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        Instituicao result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    SelecionarInstituicaoScreen()));

                        setState(() {
                          selectedInstituicao = result;
                        });
                      },
                      child: Text('Selecionar instituição')),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cargo',
                    ),
                    maxLength: 140,
                    validator: constructValidator(
                        notNullValidator, 'Preencha o campo do cargo.'),
                    controller: _controllerCargoPesquisador,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                  maxLength: 140,
                  controller: _controllerEmailPesquisador,
                  validator: constructValidator(
                      validarEmail, 'Digite um e-mail válido.'),
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text('Tipo de perfil'),
                ),
                DropdownButton(
                  value: _dropdownPerfilUtilizadorValue,
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
                      _dropdownPerfilUtilizadorValue = newValue!;
                      _dropdownPerfilUtilizadorId =
                          PerfilUtilizador.getPerfilUtilizadorId(
                              _dropdownPerfilUtilizadorValue!);
                    });
                  },
                  items: PerfilUtilizador.perfilUtilizadorValues.values
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
    if (!_cadastrarButtonPressed) {
      return ElevatedButton.icon(
        onPressed: tryRegister,
        icon: Icon(Icons.save),
        label: Text('Cadastrar'),
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

  void tryRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _cadastrarButtonPressed = true;
        });

        if (selectedInstituicao == null) {
          throw InstituicaoNotSelectedException('Instituição não foi selecionada.');
        }

        Pesquisador createdPesquisador = Pesquisador(
          uuidPesquisador: generatedUuid,
          nomePesquisador: _controllerNomePesquisador.text.toUpperCase(),
          uuidInstituicao: selectedInstituicao!.uuidInstituicao,
          cpfPesquisador: _controllerCpfPesquisador.text,
          cargoPesquisador: _controllerCargoPesquisador.text,
          emailPesquisador: _controllerEmailPesquisador.text,
          idPerfilUtilizador: _dropdownPerfilUtilizadorId,
        );

        await createdPesquisador.firestoreAdd().timeout(Duration(seconds: 5),
            onTimeout: () {
          throw TimeoutException(
              'É necessário estar conectado para registrar um novo pesquisador.');
        });

        final String generatedPassword = PasswordGenerate.generatePassword();

        await FirebaseAuthService()
            .firebaseAuthRegister(
                createdPesquisador.emailPesquisador, generatedPassword)
            .timeout(Duration(seconds: 5), onTimeout: () {
          throw TimeoutException(
              'É necessário estar conectado para registrar um novo pesquisador.');
        });

        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TelaInclusaoPesquisador(
                createdPesquisador.emailPesquisador, generatedPassword)));

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pesquisador cadastrado com sucesso!')));
      } on InstituicaoNotSelectedException {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'É necessário informar uma instituição para o pesquisador.')));
      } on TimeoutException {
        _showCustomDialog(
            'ERRO: é preciso estar conectado à Internet para registrar um pesquisador novo.');
      } on FirebaseAuthException catch (e) {
        _showCustomDialog('ERRO: o e-mail informado já está cadastrado!');
      } catch (e) {
        print(e);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Houve um erro desconhecido ao cadastrar o pesquisador: $e')));
      } finally {
        setState(() {
          _cadastrarButtonPressed = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Campos com dados inválidos ou faltando. Por favor, corrija e tente novamente.')));
    }
  }

  void _showCustomDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 200,
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.deepOrange,
                        size: 64.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}

mixin InputValidatitonMixin {
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

  bool notNullValidator(String? param) => (param != null && param.isNotEmpty);

  bool validarEmail(String? email) => (email != null &&
      email.isNotEmpty &&
      RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(email));
}
