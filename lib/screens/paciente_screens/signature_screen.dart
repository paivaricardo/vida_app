import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:vida_app/models/paciente_signature_model.dart';

class SignatureScreen extends StatefulWidget {
  final String uuidPaciente;

  const SignatureScreen({required this.uuidPaciente, Key? key}) : super(key: key);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assinar termo'),),
      body: Column(
        children: <Widget>[
          Signature(controller: _signatureController, height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.8 : MediaQuery.of(context).size.height * 0.65),
          buildButtons(context),
          
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildCheck(context),
          buildClear(),
        ],
      ),
    );
  }

  Widget buildCheck(BuildContext context) {
    return IconButton(onPressed: () async{
      if(_signatureController.isNotEmpty) {
        final signature = await exportSignature();

        final signaturePaciente = PacienteSignatureModel(
          signature: signature,
            uuidPaciente: widget.uuidPaciente,
            dateTimeAcceptance: DateTime.now(),
        );

        Navigator.pop(context, signaturePaciente);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('É necessário fornecer uma assinatura, para o aceite do termo de tratamento de dados pessoais.')));
      }

    }, icon: Icon(Icons.check_rounded));
  }

  Widget buildClear() {
    return IconButton(onPressed: () => _signatureController.clear(), icon: Icon(Icons.clear_rounded, color: Colors.red,));
  }

  Future<Uint8List> exportSignature() async{
    final exportController = SignatureController(
      points: _signatureController.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature!;

  }

}
