import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/helpers/password_helper.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class FirstAccessScreen extends StatefulWidget {
  const FirstAccessScreen({Key? key}) : super(key: key);

  @override
  _FirstAccessScreenState createState() => _FirstAccessScreenState();
}

class _FirstAccessScreenState extends State<FirstAccessScreen> {
  // FormKey
  GlobalKey<FormState> _firstAccessFormKey = GlobalKey<FormState>();

  // Firebase AuthService
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Controllers
  TextEditingController _controllerSenhaAntiga = TextEditingController();
  TextEditingController _controllerSenhaNova = TextEditingController();
  TextEditingController _controllerSenhaNovaRepeat = TextEditingController();

  // Validation error message
  String? _validationErrorMessage;

  // Mensagem de erro de login - visualizar
  bool sendError = false;
  String? _passwordErrorText = null;
  bool _pressedAlterar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _firstAccessFormKey,
                      child: Column(
                        children: [
                          GradientText.rainbow(
                            'VIDA',
                            style: TextStyle(
                                fontSize: 76.0,
                                fontFamily: 'Comfortaa',
                                fontWeight: FontWeight.bold),
                          ),
                          Text('Você é Importante Demais. Ame-se!',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey.shade700,
                                  fontFamily: 'Comfortaa')),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                'Práticas Integrativas e Complementares em Saúde',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey.shade900,
                                    fontFamily: 'Comfortaa')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                                'No seu primeiro acesso, é necessário alterar a senha para acessar a aplicação.',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey.shade900,
                                    fontFamily: 'Comfortaa')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 18.0,
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: 'Senha anterior',
                                  filled: true,
                                  fillColor: Colors.white),
                              controller: _controllerSenhaAntiga,
                              maxLength: 16,
                              obscureText: true,
                              validator: (senhaDigitada) {
                                if (senhaDigitada != null &&
                                    senhaDigitada.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'O campo da senha antiga não pode estar em branco.';
                                }
                              },
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Senha nova',
                                filled: true,
                                fillColor: Colors.white),
                            controller: _controllerSenhaNova,
                            maxLength: 16,
                            obscureText: true,
                            validator: (senhaDigitada) {
                              if (senhaDigitada != null &&
                                  senhaDigitada.isNotEmpty) {
                                if (_controllerSenhaNova.text ==
                                    _controllerSenhaNovaRepeat.text) {
                                  if (PasswordHelper.passwordRegex
                                      .hasMatch(_controllerSenhaNova.text)) {
                                    if (_controllerSenhaNova.text !=
                                        _controllerSenhaAntiga.text) {
                                      return null;
                                    } else {
                                      _validationErrorMessage =
                                          'A senha nova não pode ser igual à anterior';
                                      return _validationErrorMessage;
                                    }
                                  } else {
                                    _validationErrorMessage =
                                        r'A senha precisa conter 8 caracteres, com no mínimo 1 número, 1 letra maiúscula, 1 minúscula e 1 caractere especial (@$!%*?&).';
                                    return _validationErrorMessage;
                                  }
                                } else {
                                  _validationErrorMessage =
                                      'As senhas não conferem.';
                                  return _validationErrorMessage;
                                }
                              } else {
                                _validationErrorMessage =
                                    'Os campos não podem estar em branco.';
                                return 'O campo não pode estar em branco.';
                              }
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Repita a senha nova',
                                filled: true,
                                fillColor: Colors.white),
                            controller: _controllerSenhaNovaRepeat,
                            maxLength: 16,
                            obscureText: true,
                            validator: (senhaDigitada) {
                              if (senhaDigitada != null &&
                                  senhaDigitada.isNotEmpty) {
                                if (_controllerSenhaNova.text ==
                                    _controllerSenhaNovaRepeat.text) {
                                  if (PasswordHelper.passwordRegex
                                      .hasMatch(_controllerSenhaNova.text)) {
                                    if (_controllerSenhaNova.text !=
                                        _controllerSenhaAntiga.text) {
                                      return null;
                                    } else {
                                      return 'A senha nova não pode ser igual à anterior';
                                    }
                                  } else {
                                    _validationErrorMessage =
                                        r'A senha precisa conter 8 caracteres, com no mínimo 1 número, 1 letra maiúscula, 1 minúscula e 1 caractere especial (@$!%*?&).';
                                    return _validationErrorMessage;
                                  }
                                } else {
                                  return ('As senhas não conferem.');
                                }
                              } else {
                                return 'O campo não pode estar em branco.';
                              }
                            },
                          ),
                          loginErrorVisibility(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () async {
                                      await _firebaseAuthService
                                          .firebaseSignOut();
                                    },
                                    child: Text(
                                      'Sair',
                                      style: TextStyle(
                                          fontFamily: 'Comfortaa',
                                          fontSize: 16.0),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0))),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                  vertical: 14.0,
                                                  horizontal: 0.0)),
                                    ),
                                  ),
                                ),
                                loginButton(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Ainda não possui cadastro?',
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 18.0,
                        color: Colors.indigo.shade900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    if (_pressedAlterar) {
      return SizedBox(
        width: 150,
        height: 50,
        child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade700),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 15, height: 15, child: CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Aguarde...',
                  style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 150,
        height: 50,
        child: TextButton(
          onPressed: tryAlterar,
          child: Text(
            'Alterar',
            style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepPurple),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 14.0, horizontal: 0.0)),
          ),
        ),
      );
    }
  }

  Future<void> tryAlterar() async {
    try {
      setState(() {
        _pressedAlterar = true;
      });

      if (_firstAccessFormKey.currentState!.validate()) {
        _validationErrorMessage = null;

        String returnMessage =
            await _firebaseAuthService.firebaseChangePassword(
                _controllerSenhaAntiga.text, _controllerSenhaNova.text);

        if (returnMessage == 'Wrong password') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Senha incorreta. Tente novamente.')));

          setState(() {
            sendError = true;
            _validationErrorMessage = 'Senha incorreta.';
            _pressedAlterar = false;
          });
        } else if (returnMessage == 'Success') {
          // Pesquisador logado
          Pesquisador pesquisadorLogado =
              Provider.of<Pesquisador?>(context, listen: false)!;

          await pesquisadorLogado.updateFirstAccess();

          setState(() {
            _validationErrorMessage = null;
            _pressedAlterar = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Senha alterada com sucesso!'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_validationErrorMessage ??
                'Formulário com dados inválidos ou faltando. Por favor, confira os dados e tente novamente.')));

        setState(() {
          // _validationErrorMessage = null;
          _pressedAlterar = false;
        });
      }
    } catch (e) {
      setState(() {
        _pressedAlterar = false;
      });

      print(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ocorreu um erro ao tentar alterar a senha.')));
    }
  }

  Widget loginErrorVisibility() {
    return Visibility(
        visible: sendError,
        child: Text(
          _validationErrorMessage ?? '',
          style: TextStyle(color: Colors.redAccent, fontFamily: 'Comfortaa'),
        ));
  }
}
