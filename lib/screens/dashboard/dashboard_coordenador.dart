import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/components/gradient_text.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/conta_screens/acoes_conta_screen.dart';
import 'package:vida_app/screens/instituicoes/instituicoes_screen.dart';
import 'package:vida_app/screens/paciente_screens/lista_pacientes_screen.dart';
import 'package:vida_app/screens/pesquisadores/pesquisadores_screen.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

class DashboardCoordenador extends StatefulWidget {
  final Pesquisador pesquisadorCoordenador;

  const DashboardCoordenador(this.pesquisadorCoordenador, {Key? key})
      : super(key: key);

  @override
  _DashboardCoordenadorState createState() => _DashboardCoordenadorState();
}

class _DashboardCoordenadorState extends State<DashboardCoordenador> {
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    double canvasWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GradientText.rainbow(
          'VIDA',
          style: TextStyle(fontFamily: 'Comfortaa', fontSize: 24.0),
        ),
        actions: <Widget>[
          IconButton(onPressed: _showHelpDialog, icon: const Icon(Icons.help_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: canvasWidth,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                  Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0.0),
              child: GradientText(
                'VIDA',
                gradient:
                    LinearGradient(colors: [Colors.black, Colors.black54]),
                style: TextStyle(fontSize: 96.0, fontFamily: 'Comfortaa'),
              ),
            ),
            Text(
              'Pr??ticas Integrativas e Complementares em Sa??de',
              style: TextStyle(fontFamily: 'Comfortaa', fontSize: 12.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Bem-vindo, ${widget.pesquisadorCoordenador.nomePesquisador}!',
                style: TextStyle(fontFamily: 'Comfortaa', fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                width: canvasWidth * 0.9,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: <Widget>[
                    Material(
                      textStyle:
                          TextStyle(fontFamily: 'Comfortaa', fontSize: 14.0),
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      elevation: 10.0,
                      shadowColor: Colors.deepPurple,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ListaPacientesScreen()));
                        },
                        child: SizedBox(
                          width: 115,
                          height: 115,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Pacientes'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: Provider.of<Pesquisador?>(context)!
                              .idPerfilUtilizador ==
                          1,
                      child: Material(
                        textStyle:
                            TextStyle(fontFamily: 'Comfortaa', fontSize: 14.0),
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        elevation: 10.0,
                        shadowColor: Colors.deepPurple,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PesquisadoresScreen()));
                          },
                          child: SizedBox(
                            width: 115,
                            height: 115,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.smart_toy_rounded,
                                  color: Colors.white,
                                  size: 32.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('Pesquisadores'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      textStyle:
                          TextStyle(fontFamily: 'Comfortaa', fontSize: 14.0),
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      elevation: 10.0,
                      shadowColor: Colors.deepPurple,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AcoesContaScreen()));
                        },
                        child: SizedBox(
                          width: 115,
                          height: 115,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.settings_rounded,
                                color: Colors.white,
                                size: 32.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Conta'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      textStyle:
                          TextStyle(fontFamily: 'Comfortaa', fontSize: 14.0),
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      elevation: 10.0,
                      shadowColor: Colors.deepPurple,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InstituicoesScreen()));
                        },
                        child: SizedBox(
                          width: 115,
                          height: 115,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.style_rounded,
                                color: Colors.white,
                                size: 32.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Institui????es'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      textStyle:
                          TextStyle(fontFamily: 'Comfortaa', fontSize: 14.0),
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      elevation: 10.0,
                      shadowColor: Colors.deepPurple,
                      child: InkWell(
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'VIDA app',
                            applicationVersion: 'v1.0.0',
                            applicationIcon: Image.asset('assets/icons/android_icons/1x/Asset1mdpi.png'),
                            applicationLegalese: 'Este aplicativo ?? de propriedade da Funda????o Universidade Federal do Amap?? (UNIFAP). Todos os direitos reservados.',
                            children: <Widget>[
                              Text('A aplicativo VIDA foi desenvolvido como parte integrante de um projeto de pesquisa conduzido na Universidade Federal do Amap?? (UNIFAP), no curso de Farm??cia, referente ??s Pr??ticas Integrativas e Complementares em Sa??de (PICS) e acompanhamento de pacientes acometidos de ansiedade, depress??o, dores e cessa????o tab??gica, por meio da aplica????o de question??rios validados.'),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text('Para entrar em contato, enviar sugest??es ou reportar erros, envie um e-mail para:', style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              SelectableText('contato.vida.app@gmail.com')
                            ]
                          );
                        },
                        child: SizedBox(
                          width: 115,
                          height: 115,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.info_rounded,
                                color: Colors.white,
                                size: 32.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Sobre'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      textStyle:
                          TextStyle(fontFamily: 'Comfortaa', fontSize: 14.0),
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      elevation: 10.0,
                      shadowColor: Colors.deepPurple,
                      child: InkWell(
                        onTap: () async {

                          await _firebaseAuthService.firebaseSignOut();
                        },
                        child: SizedBox(
                          width: 115,
                          height: 115,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.white,
                                size: 32.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Sair'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(context: context, builder: (context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(32.0),
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Icon(Icons.help, size: 64.0, color: Colors.deepPurple,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text('Bem-vindo ao aplicativo VIDA!'),
                  ),
                  Text('Este ?? o menu principal da aplica????o. Aqui, voc?? poder?? acessar as listas de pacientes cadastrados no aplicativo, onde poder?? aplicar question??rios, registrar interven????es, visualizar hist??rico ou exportar PDFs. A se????o se pacientes ?? onde se concentra as principais funcionalidades da aplica????o. Fora isso, neste menu principal poder?? ter acesso aos pesquisadores cadastrados (funcionalidade dispon??vel apenas para coordenadores, que poder??o cadastrar novos pesquisadores por meio desse menu) e institui????es. Tamb??m poder?? administrar sua conta em "Conta", com possibilidade de alterar a sua senha ou visualizar os dados do seu perfil de pesquisador, previamente cadastrado. A parte "Sobre" fornece informa????es legais sobre o aplicativo, assim como dados sobre todas as licen??as utilizadas.'),
                  Text('Caso precise entrar em contato, fa??a uso do e-mail dispon??vel na se????o "Sobre"'),
                  ElevatedButton.icon(onPressed: () {
                    Navigator.pop(context);
                  }, label: Text('Fechar'), icon: Icon(Icons.close),)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
