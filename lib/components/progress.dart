import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  String message;
  Progress({this.message = 'Carregando dados..', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(message,
                    style: TextStyle(fontSize: 24.0)),
              ),
            ]));
  }
}