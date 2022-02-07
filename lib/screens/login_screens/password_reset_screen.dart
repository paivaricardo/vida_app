import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/helpers/validator_helpers.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  // FormKey
  GlobalKey<FormState> _passwordResetFormKey = GlobalKey<FormState>();

  // Firebase AuthService
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Controllers
  TextEditingController _emailController = TextEditingController();

  // Mensagem de erro de login - visualizar
  bool sendError = false;
  String sendErrorMessage = 'E-mail não localizado';
  bool sendButtonPressed = false;

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
                    child: Form(
                      key: _passwordResetFormKey,
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
                              validator: ValidatorHelpers.emailValidator,
                            ),
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
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Retornar',
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
                                              vertical: 14.0, horizontal: 0.0)),
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
    if (sendButtonPressed) {
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
          onPressed: trySend,
          child: Text(
            'Resetar',
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

  void trySend() async {
    if (_passwordResetFormKey.currentState!.validate()) {
      setState(() {
        sendButtonPressed = true;
      });

      try {
        String returnResult = await _firebaseAuthService.firebaseResetPassword(
            _emailController.text.trim());

        print('Erro : $returnResult');

        if (returnResult == 'Success') {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('E-mail de reinício de senha enviado! Confira sua caixa de e-mail!')));
          Navigator.pop(context);

        } else {

          throw FirebaseAuthException(code: 'user-not-found');
        }

      } on FirebaseAuthException catch (e) {

        if (e.code == 'network-request-failed') {
          sendErrorMessage = 'Conexão com a Internet falhou. Tente mais tarde.';
        } else if(e.code == 'user-not-found') {
          sendErrorMessage = 'E-mail não localizado.';
        } else {
          sendErrorMessage = 'Ocorreu um erro desconhecido.';
        }

        setState(() {
          sendError = true;
          sendButtonPressed = false;
        });
      } on TimeoutException catch (e) {
        setState(() {
          sendError = true;
          sendErrorMessage = 'Conexão com a Internet falhou. Tente mais tarde.';
          sendButtonPressed = false;
        });
      } catch (e) {
        setState(() {
          sendError = true;
          sendErrorMessage = 'Ocorreu um erro desconhecido.';
          sendButtonPressed = false;
        });
      }
    } else {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(
          content: Text('O e-mail digitado é invalido ou está faltando')));

      }
      }

  Widget loginErrorVisibility() {
    return Visibility(
        visible: sendError,
        child: Text(
          sendErrorMessage,
          style: TextStyle(color: Colors.redAccent, fontFamily: 'Comfortaa'),
        ));
  }

}
