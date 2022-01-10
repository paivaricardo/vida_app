import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vida_app/database/app_database.dart';
import 'package:vida_app/database/dao/paciente_conhece_pics_dao.dart';
import 'package:vida_app/database/dao/paciente_dao.dart';
import 'package:vida_app/models/escolaridade_model.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/sexo_model.dart';
import 'package:vida_app/screens/lista_questionarios_screen.dart';
import 'package:vida_app/screens/paciente_screens/cadastro_paciente_screen.dart';

void main() async {
  runApp(const VidaApp());

  final Database db = await AppDatabase.getDatabase();

  // Debug
  // Show all tables from the database
  // (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
  //   print(row.values);
  // });

  // (await db.query('paciente_conhece_pics')).forEach((row) {
  //   print(row.values);
  // });
  //
  // (await PacienteConhecePicsDAO().findQuaisPicsConhece(1))
  //     .forEach((key, value) {
  //   print('$key : $value');
  // });

  // (await PacienteDAO().findAll()).forEach((paciente) {
  //   debugPrint(paciente.toString());
  // });
}

class VidaApp extends StatelessWidget {
  const VidaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        primarySwatch: Colors.deepPurple,
      ),
      home: CadastroPacienteScreen(),
    );
  }
}
