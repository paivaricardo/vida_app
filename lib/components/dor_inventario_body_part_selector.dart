import 'package:flutter/material.dart';
import 'package:vida_app/models/questionario_dor_inventario_model.dart';

class DorInventarioBodyPartSelector extends StatefulWidget {
  final int bodyPartNumber;
  final double modulo;
  final QuestionarioDorInventario questionarioDorInventario;

  const DorInventarioBodyPartSelector({required this.bodyPartNumber, required this.modulo, required this.questionarioDorInventario, Key? key}) : super(key: key);

  @override
  _DorInventarioBodyPartSelectorState createState() => _DorInventarioBodyPartSelectorState();
}

class _DorInventarioBodyPartSelectorState extends State<DorInventarioBodyPartSelector> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        width: widget.modulo * QuestionarioDorInventario.modularizedBodyPartsPositions[widget.bodyPartNumber]!['size']!,
        height: widget.modulo * QuestionarioDorInventario.modularizedBodyPartsPositions[widget.bodyPartNumber]!['size']!,
        top: widget.modulo * QuestionarioDorInventario.modularizedBodyPartsPositions[widget.bodyPartNumber]!['top']!,
        left: widget.modulo * QuestionarioDorInventario.modularizedBodyPartsPositions[widget.bodyPartNumber]!['left']!,
        child: ClipOval(
          child: Opacity(
            opacity: 0.7,
            child: Material(
              color: pressed? Colors.purple : Colors.grey,
              child: InkWell(
                onTap: () {
                  setState(() {
                    pressed = !pressed;
                    widget.questionarioDorInventario.painMapBody[widget.bodyPartNumber.toString()] = pressed? 1 : 0;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
