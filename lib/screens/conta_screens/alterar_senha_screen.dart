import 'package:flutter/material.dart';
import 'package:vida_app/helpers/password_helper.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class AlterarSenhaScreen extends StatefulWidget {
  AlterarSenhaScreen({Key? key}) : super(key: key);

  @override
  State<AlterarSenhaScreen> createState() => _AlterarSenhaScreenState();
}

class _AlterarSenhaScreenState extends State<AlterarSenhaScreen> {
  // Form key
  GlobalKey<FormState> _formPasswordKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _controllerSenhaAntiga = TextEditingController();
  TextEditingController _controllerSenhaNova = TextEditingController();
  TextEditingController _controllerSenhaNovaRepeat = TextEditingController();

  // Firebase AuthService instance
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Error text
  String? _passwordErrorText;

  // Alterar button pressed
  bool _pressedAlterar = false;

  // Validation error message
  String? _validationErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alterar senha')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formPasswordKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Senha antiga'),
                    errorText: _passwordErrorText,
                  ),
                  maxLength: 16,
                  obscureText: true,
                  controller: _controllerSenhaAntiga,
                  validator: (senhaDigitada) {
                    if (senhaDigitada != null && senhaDigitada.isNotEmpty) {
                      return null;
                    } else {
                      return 'O campo da senha antiga não pode estar em branco.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Senha nova'),
                  ),
                  maxLength: 16,
                  obscureText: true,
                  controller: _controllerSenhaNova,
                  validator: (senhaDigitada) {
                    if (senhaDigitada != null && senhaDigitada.isNotEmpty) {
                      if (_controllerSenhaNova.text ==
                          _controllerSenhaNovaRepeat.text) {
                        if (PasswordHelper.passwordRegex
                            .hasMatch(_controllerSenhaNova.text)) {

                          if(_controllerSenhaNova.text != _controllerSenhaAntiga.text) {
                            return null;
                          } else {
                            return 'A senha nova não pode ser igual à anterior';
                          }

                        } else {
                          _validationErrorMessage = r'A senha precisa conter 8 caracteres, com no mínimo 1 número, 1 letra maiúscula, 1 minúscula e 1 caractere especial (@$!%*?&).';
                          return _validationErrorMessage;
                        }
                      } else {
                        return 'As senhas não conferem.';
                      }
                    } else {
                      return 'O campo não pode estar em branco.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text('Repita a senha nova'),
                  ),
                  maxLength: 16,
                  obscureText: true,
                  controller: _controllerSenhaNovaRepeat,
                  validator: (senhaDigitada) {
                    if (senhaDigitada != null && senhaDigitada.isNotEmpty) {
                      if (_controllerSenhaNova.text ==
                          _controllerSenhaNovaRepeat.text) {
                        if (PasswordHelper.passwordRegex
                            .hasMatch(_controllerSenhaNova.text)) {

                          if(_controllerSenhaNova.text != _controllerSenhaAntiga.text) {
                            return null;
                          } else {
                            return 'A senha nova não pode ser igual à anterior';
                          }

                        } else {
                          return r'A senha precisa conter 8 caracteres, com no mínimo 1 número, 1 letra maiúscula, 1 minúscula e 1 caractere especial (@$!%*?&).';
                        }
                      } else {
                        return 'As senhas não conferem.';
                      }
                    } else {
                      return 'O campo não pode estar em branco.';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: Text('Cancelar'),
                        icon: Icon(Icons.cancel_rounded),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                        ),
                      ),
                      buildPressedButton(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPressedButton() {
    if (_pressedAlterar) {
      return ElevatedButton.icon(
          onPressed: () {},
          icon: CircularProgressIndicator(),
          label: Text('Aguarde'));
    } else {
      return ElevatedButton.icon(
        onPressed: tryAlterar,
        label: Text('Alterar'),
        icon: Icon(Icons.check_rounded),
      );
    }
  }

  Future<void> tryAlterar() async {
    try {
      setState(() {
        _passwordErrorText = null;
        _pressedAlterar = true;
      });

      if (_formPasswordKey.currentState!.validate()) {
        String returnMessage =
            await _firebaseAuthService.firebaseChangePassword(
                _controllerSenhaAntiga.text, _controllerSenhaNova.text);

        if (returnMessage == 'Wrong password') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Senha incorreta. Tente novamente.')));

          setState(() {
            _passwordErrorText = 'Senha incorreta.';
            _pressedAlterar = false;
          });
        } else if (returnMessage == 'Success') {
          setState(() {
            _passwordErrorText = null;
            _pressedAlterar = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Senha alterada com sucesso!')));
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_validationErrorMessage ??
                'Formulário com dados inválidos ou faltando. Por favor, confira os dados e tente novamente.')));

        setState(() {
          _validationErrorMessage = null;
          _pressedAlterar = false;
        });
      }
    } catch (e) {
      setState(() {
        _pressedAlterar = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ocorreu um erro ao tentar alterar a senha.')));
    }
  }
}
