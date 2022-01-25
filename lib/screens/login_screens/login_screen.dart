import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Mensagem de erro de login - visualizar
  bool loginError = false;
  String loginErrorMessage = 'E-mail ou senha incorretos';
  bool loginButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IntrinsicHeight(
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
                          padding: const EdgeInsets.only(
                            top: 18.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'E-mail',
                                filled: true,
                                fillColor: Colors.white),
                            controller: _emailController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: 'Senha',
                                filled: true,
                                fillColor: Colors.white),
                            obscureText: true,
                            controller: _passwordController,
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                  color: Colors.indigo.shade900,
                                  fontFamily: 'Comfortaa'),
                            )),
                        loginErrorVisibility(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: loginButton(),
                        )
                      ],
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
    if (loginButtonPressed == true) {
      return SizedBox(
        width: 150,
        height: 50,
        child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10.0))),
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.grey.shade700),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 16.0)),
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
                  style: TextStyle(
                      fontFamily: 'Comfortaa', fontSize: 16.0),
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
          onPressed: tryLogin,
          child: Text(
            'Entrar',
            style: TextStyle(
                fontFamily: 'Comfortaa', fontSize: 16.0),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10.0))),
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.deepPurple),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 0.0)),
          ),
        ),
      );
    }
  }

  void tryLogin() async {
    setState(() {
      loginButtonPressed = true;
    });

    try {
      Pesquisador? pesquisadorLogado =
      await _firebaseAuthService.firebaseAuthsignIn(
          _emailController.text,
          _passwordController.text).timeout(
          Duration(seconds: 5), onTimeout: () {
        throw TimeoutException(
            'Não há conexão com a Internet')
      });

      if (pesquisadorLogado == null) {
        setState(() {
          loginError = true;
          loginErrorMessage =
          'E-mail ou senha incorretos.';
          loginButtonPressed = false;
        });

        // Usando do
        //   PROVIDER para gerenciar os estados de autenticação. O código abaixo não é mais utilizado e está aqui somente como referência.
        // setState(()
        // {
        //   loginError = false;
        // });

        // Pesquisador.loggedInPesquisador = pesquisadorLogado;

        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => DashboardCoordenador(pesquisadorLogado)));

      }
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == 'network-request-failed') {
        loginErrorMessage = 'Conexão com a Internet falhou. Tente mais tarde.';
      } else {
        loginErrorMessage =
        'E-mail ou senha incorretos.';
      }

      setState(() {
        loginError = true;
        loginButtonPressed = false;
      });
    } on TimeoutException catch (e) {
      setState(() {
        loginError = true;
        loginErrorMessage =
        'Conexão com a Internet falhou. Tente mais tarde.';
        loginButtonPressed = false;
      });
    } catch (e) {
      setState(() {
        loginError = true;
        loginErrorMessage =
        'Ocorreu um erro desconhecido.';
        loginButtonPressed = false;
      });
    }
  }

  Widget loginErrorVisibility() {
    return Visibility(
        visible: loginError,
        child: Text(
          loginErrorMessage,
          style: TextStyle(
              color: Colors.redAccent,
              fontFamily: 'Comfortaa'),
        ));
  }

}
