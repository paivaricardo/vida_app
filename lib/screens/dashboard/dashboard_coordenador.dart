import 'package:flutter/material.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/instituicoes/instituicoes_screen.dart';
import 'package:vida_app/screens/paciente_screens/lista_pacientes_screen.dart';
import 'package:vida_app/screens/pesquisadores/pesquisadores_screen.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class DashboardCoordenador extends StatefulWidget {
  final Pesquisador pesquisadorCoordenador;

  const DashboardCoordenador(this.pesquisadorCoordenador, {Key? key}) : super(key: key);

  @override
  _DashboardCoordenadorState createState() => _DashboardCoordenadorState();
}

class _DashboardCoordenadorState extends State<DashboardCoordenador> {
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  void initState() {
    assert (widget.pesquisadorCoordenador == Pesquisador.loggedInPesquisador);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GradientText.rainbow(
          'VIDA',
          style: TextStyle(fontFamily: 'Comfortaa', fontSize: 24.0),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24.0, 0, 8.0),
            child: GradientText(
              'VIDA',
              gradient: LinearGradient(colors: [Colors.black, Colors.black54]),
              style: TextStyle(fontSize: 128.0, fontFamily: 'Comfortaa'),
            ),
          ),
          Text(
            'Bem-vindo, ${Pesquisador.loggedInPesquisador!.nomePesquisador}!',
            style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Material(
                    textStyle:
                        TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(34.0)),
                    elevation: 10.0,
                    shadowColor: Colors.deepPurple,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListaPacientesScreen()));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 64.0,
                            ),
                          ),
                          Text('Pacientes')
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Material(
                    textStyle:
                        TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(34.0)),
                    elevation: 10.0,
                    shadowColor: Colors.deepPurple,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PesquisadoresScreen()));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.white,
                              size: 64.0,
                            ),
                          ),
                          Text('Pesquisadores')
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Material(
                    textStyle:
                        TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(34.0)),
                    elevation: 10.0,
                    shadowColor: Colors.deepPurple,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InstituicoesScreen()));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Icon(
                              Icons.style_rounded,
                              color: Colors.white,
                              size: 64.0,
                            ),
                          ),
                          Text('Instituições')
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Material(
                    textStyle:
                        TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.all(Radius.circular(34.0)),
                    elevation: 10.0,
                    shadowColor: Colors.deepPurple,
                    child: InkWell(
                      onTap: () async {

                        Pesquisador.loggedInPesquisador = null;

                        await _firebaseAuthService.firebaseSignOut();

                      },
                      child: SizedBox(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.white,
                                size: 64.0,
                              ),
                            ),
                            Text('Sair')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
