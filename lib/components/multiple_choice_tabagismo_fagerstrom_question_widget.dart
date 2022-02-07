import 'package:flutter/material.dart';
import 'package:vida_app/models/questao_model.dart';
import 'package:vida_app/models/questao_questionario_domain_model.dart';

class MultipleChoiceTabagismoFagerstromQuestionWidget extends StatefulWidget {
  Questao question;

  MultipleChoiceTabagismoFagerstromQuestionWidget(
      {required this.question, Key? key})
      : super(key: key);

  @override
  _MultipleChoiceTabagismoFagerstromQuestionWidgetState createState() =>
      _MultipleChoiceTabagismoFagerstromQuestionWidgetState();
}

class _MultipleChoiceTabagismoFagerstromQuestionWidgetState
    extends State<MultipleChoiceTabagismoFagerstromQuestionWidget> {
  late Map<int, String> choicesQuestionMap =
      QuestaoQuestionarioDomain.questionarioTabagismoFagerstromQuestoesChoices[
          widget.question.ordemQuestaoDomain]!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${widget.question.ordemQuestaoDomain} ${widget.question.descricao}'),
          for(int i = 0; i <= choicesQuestionMap.length - 1; i++) ...[
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
