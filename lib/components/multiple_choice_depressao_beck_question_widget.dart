import 'package:flutter/material.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';

class MultipleChoiceDepressaoBeckQuestionWidget extends StatefulWidget {
  Questao question;

  MultipleChoiceDepressaoBeckQuestionWidget(
      {required this.question, Key? key})
      : super(key: key);

  @override
  _MultipleChoiceDepressaoBeckQuestionWidgetState createState() =>
      _MultipleChoiceDepressaoBeckQuestionWidgetState();
}

class _MultipleChoiceDepressaoBeckQuestionWidgetState
    extends State<MultipleChoiceDepressaoBeckQuestionWidget> {
  late Map<int, String> choicesQuestionMap =
      QuestaoQuestionarioDomain.questionarioDepressaoBeckQuestoesValues[
          widget.question.ordemQuestaoDomain]!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Questão ${widget.question.ordemQuestaoDomain}', ),
          for (int i = 0; i <= choicesQuestionMap.length - 1; i++) ...[
            ListTile(
              title: Text(choicesQuestionMap[i]!),
              leading: Radio<int>(
                groupValue: widget.question.pontuacao,
                value: i,
                onChanged: (value) {
                  setState(() {
                    widget.question.pontuacao = value!;
                  });
                },
              ),
            )
          ],
        ],
      ),
    );
  }
}
