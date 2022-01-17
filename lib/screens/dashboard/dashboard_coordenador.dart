import 'package:flutter/material.dart';
import 'package:vida_app/components/gradient_text.dart';

class DashboardCoordenador extends StatefulWidget {
  const DashboardCoordenador({Key? key}) : super(key: key);

  @override
  _DashboardCoordenadorState createState() => _DashboardCoordenadorState();
}

class _DashboardCoordenadorState extends State<DashboardCoordenador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText.rainbow('VIDA', style: TextStyle(fontFamily: 'Comfortaa', fontSize: 24.0),),
      ),
      body: Center(
        child: Text('Bem-vindo ao VIDA!'),
      ),
    );
  }
}
