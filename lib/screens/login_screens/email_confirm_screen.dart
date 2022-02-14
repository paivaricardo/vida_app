import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/helpers/validator_helpers.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class EmailConfirmScreen extends StatefulWidget {
  const EmailConfirmScreen({Key? key}) : super(key: key);

  @override
  _EmailConfirmScreenState createState() => _EmailConfirmScreenState();
}

class _EmailConfirmScreenState extends State<EmailConfirmScreen> {
  // Firebase AuthService
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Timers
  Timer? timerCheckEmail;
  Timer? timerCanResend;
  Timer? timerCountdownButton;
  int countDown = 60;

  bool isEmailVerified = false;

  bool sendError = false;
  bool sendButtonPressed = false;
  String? sendErrorMessage;

  // Current Firebase User
  late User currentFirebaseUser = _firebaseAuthService.currentUser!;

  @override
  void initState() {
    super.initState();

    isEmailVerified = currentFirebaseUser.emailVerified;

    if (!currentFirebaseUser.emailVerified) {
      currentFirebaseUser.sendEmailVerification();

      timerCheckEmail = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    timerCheckEmail?.cancel();
    timerCountdownButton?.cancel();

    super.dispose();
  }

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
                            child: Text(
                              'É necessário confirmar o endereço de e-mail para acessar a aplicação.',
                              style: TextStyle(
                                  fontFamily: 'Comfortaa', fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Uma nova mensagem de confirmação de e-mail foi enviada à sua caixa.',
                              style: TextStyle(
                                  fontFamily: 'Comfortaa', fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Verifique a mensagem enviada em sua caixa de e-mail (certifique-se de que não caiu na caixa SPAM) e clique no link contido no corpo dela para confirmar o seu e-mail.',
                              style: TextStyle(
                                  fontFamily: 'Comfortaa', fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Se não recebeu a mensagem, aperte o botão abaixo para reenviar a mensagem de confirmação de e-mail.',
                              style: TextStyle(
                                  fontFamily: 'Comfortaa', fontSize: 14.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 165,
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
                                sendEmailButton(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendEmailButton() {
    if (sendButtonPressed) {
      return SizedBox(
        width: 165,
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
                  'Enviado (${countDown})',
                  style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 165,
        height: 50,
        child: TextButton(
          onPressed: resendVerificationEmail,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Reenviar',
                  style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                ),
              ),
            ],
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

  Future resendVerificationEmail() async {
    try {
      await currentFirebaseUser.sendEmailVerification();

      setState(() {
        sendButtonPressed = true;
        startButtonTimer();
      });
      
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ocorreu um erro: $e')));
    }

  }

  Future checkEmailVerified() async{

    await _firebaseAuthService.currentUser!.reload();

    setState(() {
      isEmailVerified = _firebaseAuthService.currentUser!.emailVerified;
      print('Email Verified? $isEmailVerified');
    });

    if(isEmailVerified) {
      timerCheckEmail?.cancel();
      await _firebaseAuthService.currentUser!.reload();
      Phoenix.rebirth(context);
    }

  }

  void startButtonTimer() {
    timerCountdownButton = Timer.periodic(Duration(seconds: 1), (timerButton) {
      if(countDown == 0) {
        setState(() {
          timerButton.cancel();
          countDown = 60;
          sendButtonPressed = false;
        });
      } else {
        setState(() {
          countDown--;
        });
      }
    });
  }
}
