import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/dashboard/dashboard_coordenador.dart';
import 'package:vida_app/screens/login_screens/email_confirm_screen.dart';
import 'package:vida_app/screens/login_screens/first_access_screen.dart';
import 'package:vida_app/screens/login_screens/login_screen.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

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
      User firebaseUser = FirebaseAuthService().currentUser!;

      if (pesquisador.icAuthorized && pesquisador.icActive) {
        if (firebaseUser.emailVerified) {
          if (pesquisador.firstAccess) {
            return FirstAccessScreen();
          } else {
            switch (pesquisador.idPerfilUtilizador) {
              case 1:
                return DashboardCoordenador(pesquisador);
              default:
                return DashboardCoordenador(pesquisador);
            }
          }
        } else {
          return EmailConfirmScreen();
        }
      } else {
        return Center(
            child: Text(
                'Usuário foi desativado ou não está autorizado a acessar a aplicação.'));
      }
    }
  }
}
