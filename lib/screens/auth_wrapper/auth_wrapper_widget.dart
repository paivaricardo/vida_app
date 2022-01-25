import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/dashboard/dashboard_coordenador.dart';
import 'package:vida_app/screens/login_screens/login_screen.dart';

class AuthWrapperWidget extends StatelessWidget {
  const AuthWrapperWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Pesquisador? pesquisador = Provider.of<Pesquisador?>(context);

    // Return either Dashboard or Login Widgets
    if (pesquisador == null) {
      return LoginScreen();
    } else {
      Pesquisador.loggedInPesquisador = pesquisador;

      switch (pesquisador.idPerfilUtilizador) {
        case 1:
          return DashboardCoordenador(pesquisador);
        case 2:
          return DashboardCoordenador(pesquisador);
      }
    }

    return LoginScreen();

  }
}
