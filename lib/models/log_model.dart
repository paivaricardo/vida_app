import 'package:cloud_firestore/cloud_firestore.dart';

class LogModel {
  DateTime dateTimeLog;
  String eventType;
  String? comments;
  Map<String, dynamic>? additionalInfo;

  LogModel(
      {required this.dateTimeLog,
      required this.eventType,
      this.comments,
      this.additionalInfo});

  static const String firestoreCollectionName = 'logs';

  static Map<int, String> eventTypesMap = {
    1 : 'CREATE',
    2 : 'READ',
    3 : 'UPDATE',
    4 : 'DELETE',
    5 : 'CONSENT_DATA',
    5 : 'ACCEPT_CONFIDENTIALITY_RESEARCHER',
    6 : 'AUTHORIZE_RESEARCHER',
    7 : 'EXPORT_PDF_QUESTIONNAIRE',
  };

  Map<String, dynamic> toJson() {
    return {
      'dateTimeLog': dateTimeLog,
      'eventType': eventType,
      'comments': comments,
      'additionalInfo': additionalInfo,
    };
  }

  Future<void> firestoreAdd() {
    CollectionReference logs =
    FirebaseFirestore.instance.collection(firestoreCollectionName);

    return logs.add(toJson());
  }

}
