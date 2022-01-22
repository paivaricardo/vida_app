import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double size;
  final Color color;

  const TitleText(this.title, {this.color = Colors.black, this.size = 24.0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: color),
    );
  }
}
