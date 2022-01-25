import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vida_app/models/pesquisador_model.dart';
import 'package:vida_app/screens/auth_wrapper/auth_wrapper_widget.dart';
import 'package:vida_app/services/firebase_auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const VidaApp());

}

class VidaApp extends StatelessWidget {
  const VidaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Pesquisador?>.value(
      value: FirebaseAuthService().pesquisador,
      initialData: null,
      child: MaterialApp(
        title: 'VIDA',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.purple,
        ),
        home: AuthWrapperWidget(),
      ),
    );
  }
}
