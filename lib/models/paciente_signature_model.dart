import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class PacienteSignatureModel {
  Uint8List signature;
  String? imageUploadedUrl;
  String uuidPaciente;
  DateTime dateTimeAcceptance;

  PacienteSignatureModel(
      {required this.signature,
      required this.uuidPaciente,
      required this.dateTimeAcceptance});

  static const String firestoreCollectionName = 'pacienteAssinatura';

  Map<String, dynamic> toJson() {
    return {
      'signature': imageUploadedUrl,
      'uuidPaciente': uuidPaciente,
      'dateTimeAcceptance': dateTimeAcceptance,
    };
  }

  Future<void> firestoreAdd() async {
    CollectionReference pacienteAssinatura =
    FirebaseFirestore.instance.collection(firestoreCollectionName);

    imageUploadedUrl = await uploadSignatureImage(signature);

    if (imageUploadedUrl != 'Error') {
      return pacienteAssinatura.doc(uuidPaciente).set(toJson());
    } else {
      throw Exception('Error uploading the image file');
    }

  }

  Future<String> uploadSignatureImage(Uint8List imageBytes) async {

    firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref('signatures/${uuidPaciente}.png');

    try {
      // Upload raw data.
      await ref.putData(imageBytes);

      firebase_storage.TaskSnapshot taskSnapshot = await ref.putData(imageBytes);

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;

    } on FirebaseException catch (e) {
      print(e);
      return 'Error';
      // e.g, e.code == 'canceled'
    }
  }

}
