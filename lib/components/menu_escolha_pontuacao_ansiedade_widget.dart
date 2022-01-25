import 'package:flutter/material.dart';
import 'package:vida_app/models/questao_model.dart';

class MenuEscolhaPontuacaoQuestaoWidget extends StatefulWidget {
  final String opcaoInicial;
  final List<String> opcoesMenu;
  Questao questao;

  MenuEscolhaPontuacaoQuestaoWidget({
    required String this.opcaoInicial,
    required this.opcoesMenu,
    required this.questao,
    Key? key,
  }) : super(key: key);

  @override
  State<MenuEscolhaPontuacaoQuestaoWidget> createState() =>
      _MenuEscolhaPontuacaoQuestaoWidgetState();
}

class _MenuEscolhaPontuacaoQuestaoWidgetState
    extends State<MenuEscolhaPontuacaoQuestaoWidget> {
  // @override
  // void initState() {
  //   dropdownValue = widget.opcaoInicial;
  // }

  late String dropdownValue = widget.opcaoInicial;
  late List<String> _menuOptions = widget.opcoesMenu;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.questao.pontuacao = _assignPoints(dropdownValue);
        });
      },
      items: _menuOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  int _assignPoints(String dropdownValue) {
    return widget.opcoesMenu.indexOf(dropdownValue);
  }
}
