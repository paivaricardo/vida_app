import 'package:sqflite/sqflite.dart';
import 'package:vida_app/database/app_database.dart';
import 'package:vida_app/models/paciente_conhece_pics.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/pics_model.dart';

class PacienteConhecePicsDAO {
  static final _tableName = PacienteConhecePics.tableName;

  Future<List<int>> saveAll(Paciente paciente) async {
    final Database db = await AppDatabase.getDatabase();

    final List<int> returnedIds = [];

    paciente.quaisPicConhece.forEach((key, value) async {
      if (value == true) {
        int returnedId = await save(paciente, Pics.getPicId(key), db);
        returnedIds.add(returnedId);
      }
    });

    return returnedIds;
  }

  Future<int> save(Paciente paciente, int picId, Database db) {
    Map<String, dynamic> pacienteConhecePicsMap = _toMap(paciente, picId);

    return db.insert(_tableName, pacienteConhecePicsMap);
  }

  Map<String, dynamic> _toMap(Paciente paciente, int picId) {
    final Map<String, dynamic> pacienteConhecePicsMap = Map();

    pacienteConhecePicsMap['id_paciente'] = paciente.id;
    pacienteConhecePicsMap['id_pic'] = picId;

    return pacienteConhecePicsMap;

  }

  Future<Map<String, bool>> findQuaisPicsConhece(int pacienteId) async {
    final Database db = await AppDatabase.getDatabase();

    Map<String, bool> picsConhecidas = {
      'Reflexologia podal': false,
      'Aromaterapia': false,
      'Auriculoterapia': false,
      'Cromoterapia': false,
    };

    // final List<Map<String, dynamic>> result = await db.query(_tableName,
    //   columns: ['id_pic'],
    //   where: '"id_pic" = ?',
    //   whereArgs: [pacienteId],
    // );

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT nome_pic FROM pics INNER JOIN paciente_conhece_pics ON pics.id_pic = paciente_conhece_pics.id_pic WHERE id_paciente = $pacienteId '
    );

    result.forEach((element) {
      picsConhecidas.forEach((key, value) {

        if (element['nome_pic'] == key) {
          picsConhecidas[key] = true;
        }

      });
    });

    return picsConhecidas;

  }

}