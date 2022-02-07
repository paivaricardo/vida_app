import 'package:flutter/material.dart';
import 'package:vida_app/helpers/datetime_helper.dart';
import 'package:vida_app/screens/questionario_dor_inventario/questionario_dor_inventario_screen.dart';

class AddDrugWidget extends StatelessWidget {
  AddDrugWidget({Key? key}) : super(key: key);

  TextEditingController controllerNomeMedicamento = TextEditingController();
  TextEditingController controllerDoseMedicamento = TextEditingController();
  TextEditingController controllerDataMedicamento = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome do medicamento',
                  ),
                  controller: controllerNomeMedicamento,
                  maxLength: 50,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Dose/frequência',
                  ),
                  controller: controllerDoseMedicamento,
                  maxLength: 50,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Data de início',
                    hintText: 'ex.: 31/12/2016 - digite apenas números',
                  ),
                  controller: controllerDataMedicamento,
                  inputFormatters: [DateTimeHelper.dateMaskFormatter],
                  validator: (dataDesdeQuando) {
                    if (dataDesdeQuando == null ||
                        DateTimeHelper.regExpData.hasMatch(dataDesdeQuando)) {
                      if (dataDesdeQuando != null) {
                        if (DateTimeHelper.dateParse(dataDesdeQuando).isAfter(
                                    context
                                        .findAncestorStateOfType<
                                            QuestionarioDorInventarioScreenState>()!
                                        .questionarioDorInventario
                                        .paciente
                                        .dataNascimento) &&
                                DateTimeHelper.dateParse(dataDesdeQuando)
                                    .isBefore(DateTime.now()) ||
                            DateTimeHelper.dateParse(dataDesdeQuando)
                                .isAtSameMomentAs(DateTime.now())) {
                          return null;
                        } else {
                          return 'A data deve estar entre o nascimento do paciente e hoje.';
                        }
                      }

                      return null;
                    } else {
                      return 'Digite uma data válida.';
                    }
                  },
                  maxLength: 10,
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Material(
                child: InkWell(
                  onTap: () {
                    QuestionarioDorInventarioScreenState ancestor =
                        context.findAncestorStateOfType<
                            QuestionarioDorInventarioScreenState>()!;

                    ancestor.setState(() {
                      ancestor.addDrugsWidgetsList.remove(this);
                    });
                  },
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
