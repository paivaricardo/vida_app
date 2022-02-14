import 'package:flutter/material.dart';
import 'package:vida_app/components/termo_aceite_tratamento_dados_pessoais.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/paciente_signature_model.dart';
import 'package:vida_app/screens/paciente_screens/signature_screen.dart';

class DialogAssinaturaTermoTratamentoDados extends StatefulWidget {
  final Paciente paciente;

  const DialogAssinaturaTermoTratamentoDados({required this.paciente, Key? key})
      : super(key: key);

  @override
  _DialogAssinaturaTermoTratamentoDadosState createState() =>
      _DialogAssinaturaTermoTratamentoDadosState();
}

class _DialogAssinaturaTermoTratamentoDadosState
    extends State<DialogAssinaturaTermoTratamentoDados> {
  bool signed = false;
  PacienteSignatureModel? pacienteSignatureDialog;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TermoAceiteTratamentoDadosPessoais(),
                Visibility(
                    visible: signed,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            child: signed
                                ? ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: 1, minWidth: 1),
                                    child: Image(
                                        image: MemoryImage(
                                            pacienteSignatureDialog!
                                                .signature)),
                                  )
                                : Icon(Icons.landscape),
                          ),
                        ),
                        Text(widget.paciente.nome),
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context, pacienteSignatureDialog);
                            },
                            icon: Icon(Icons.check_rounded),
                            label: Text('Aceitar termo')),
                      ],
                    )),
                ElevatedButton.icon(
                  onPressed: () async {
                    pacienteSignatureDialog = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignatureScreen(
                                  paciente: widget.paciente,
                                )));

                    if (pacienteSignatureDialog != null) {
                      setState(() {
                        signed = true;
                      });
                    }
                  },
                  label: Text(signed ? 'Editar assinatura' : 'Assinar termo'),
                  icon: Icon(Icons.edit),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel_rounded),
                  label: Text('Cancelar'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
