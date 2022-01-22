import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/firebase_client/flutterfire.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/dashboard/dashboard_coordenador.dart';
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
                          padding: const EdgeInsets.only(
                            top: 32.0,
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
                        Visibility(
                        visible: loginError,
                        child: Text('E-mail ou senha incorretos.', style: TextStyle(color: Colors.redAccent, fontFamily: 'Comfortaa'),)),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: () async {

                              UserCredential? userCredential = await _firebaseAuthService.firebaseAuthsignIn(
                                  _emailController.text, _passwordController.text);

                              if (userCredential != null) {
                                setState(() {
                                  loginError = false;
                                });

                                Pesquisador pesquisadorLogado = await Pesquisador.getPesquisadorfromCredential(userCredential);
                                Pesquisador.loggedInPesquisador = pesquisadorLogado;

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DashboardCoordenador(pesquisadorLogado)));
                              } else {

                                setState(() {
                                  loginError = true;
                                });
                              }
                            },
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                  fontFamily: 'Comfortaa', fontSize: 16.0),
                            ),
                            style: ButtonStyle(
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurple),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 28.0)),
                            ),
                          ),
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
}
