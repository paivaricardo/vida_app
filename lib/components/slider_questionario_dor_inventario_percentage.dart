import 'package:flutter/material.dart';
import 'package:vida_app/models/questao_model.dart';

class SliderQuestionarioDorInventarioPercentage extends StatefulWidget {
  final Questao questao;
  final String beginLabel;
  final String endLabel;
  final double labelSizes;
  final bool enabled;

  const SliderQuestionarioDorInventarioPercentage({required this.questao, this.beginLabel = 'Sem alívio', this.endLabel = 'Alívio completo', this.labelSizes = 60.0, this.enabled = true,  Key? key}) : super(key: key);

  @override
  _SliderQuestionarioDorInventarioPercentageState createState() => _SliderQuestionarioDorInventarioPercentageState();
}

class _SliderQuestionarioDorInventarioPercentageState extends State<SliderQuestionarioDorInventarioPercentage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: widget.labelSizes, child: Text(widget.beginLabel)),
        Expanded(
          child: Slider(
            value: widget.questao.pontuacao
                .toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: '${widget.questao.pontuacao.toString()}%',
            onChanged: widget.enabled ? (newPontuacao) {
              setState(() {
                widget.questao.pontuacao = newPontuacao.toInt();
              });
            } : (value) {},
          ),
        ),
        SizedBox(width: widget.labelSizes,child: Text(widget.endLabel)),
      ],
    );
  }
}
