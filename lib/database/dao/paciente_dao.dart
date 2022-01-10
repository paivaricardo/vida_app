import 'package:sqflite/sqflite.dart';
import 'package:vida_app/database/app_database.dart';
import 'package:vida_app/database/dao/paciente_conhece_pics_dao.dart';
import 'package:vida_app/models/paciente_model.dart';
import 'package:vida_app/models/escolaridade_model.dart';
import 'package:vida_app/models/sexo_model.dart';

class PacienteDAO {
  static final _tableName = Paciente.tableName;
  final PacienteConhecePicsDAO _pacienteConhecePicsDAO =
      PacienteConhecePicsDAO();

  Future<List<Paciente>> findAll() async {
    final Database db = await AppDatabase.getDatabase();
    List<Paciente> pacientes = await _toList(db);
    return pacientes;
  }

  Future<int> save(Paciente paciente) async {
    final Database db = await AppDatabase.getDatabase();
    Map<String, dynamic> pacienteMap = _toMap(paciente);

    return db.insert(_tableName, pacienteMap);
  }

  Map<String, dynamic> _toMap(Paciente paciente) {
    final Map<String, dynamic> pacienteMap = Map();

    pacienteMap['nome'] = paciente.nome;
    pacienteMap['data_nascimento'] = paciente.dataNascimento.toString();
    pacienteMap['profissao'] = paciente.profissao;
    pacienteMap['id_sexo'] = Sexo.getSexoId(paciente.sexo);
    pacienteMap['id_escolaridade'] =
        Escolaridade.getEscolaridadeId(paciente.escolaridade);
    pacienteMap['peso'] = paciente.pesoAtual;
    pacienteMap['altura'] = paciente.altura;
    pacienteMap['conhece_pic'] = paciente.conhecePic.toString();
    pacienteMap['apresenta_ansiedade'] = paciente.apresentaAnsiedade.toString();
    pacienteMap['apresenta_depressao'] = paciente.apresentaDepressao.toString();
    pacienteMap['apresenta_dor'] = paciente.apresentaDor.toString();
    pacienteMap['local_dor'] = paciente.localDor;
    pacienteMap['fumante'] = paciente.fumante.toString();
    pacienteMap['frequencia_fumo'] = paciente.frequenciaFumo;
    pacienteMap['cigarros_dia'] = paciente.cigarrosDia;
    pacienteMap['faz_uso_medicamento'] = paciente.fazUsoMedicamento.toString();
    pacienteMap['medicamentos'] = paciente.medicamentos;

    return pacienteMap;
  }

  Future<List<Paciente>> _toList(Database db) async {
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Paciente> listaPacientes = [];

    await Future.wait(result.map((row) async {
      int idPaciente = int.parse(row['id_paciente'].toString());

      Map<String, bool> quaisPicConhece =
          await _pacienteConhecePicsDAO.findQuaisPicsConhece(idPaciente);

      Paciente retrievedPaciente = Paciente(
        id: int.parse(row['id_paciente'].toString()),
        nome: row['nome'],
        dataNascimento: DateTime.parse(row['data_nascimento'].toString()),
        sexo: Sexo.getSexoValue(int.parse(row['id_sexo'].toString())),
        escolaridade: Escolaridade.getEscolaridadeValue(
            int.parse(row['id_escolaridade'].toString())),
        profissao: row['profissao'],
        pesoAtual: double.parse(row['peso'].toString()),
        altura: double.parse(row['altura'].toString()),
        conhecePic: row['conhece_pic'].toString().toLowerCase() == 'true',
        quaisPicConhece: quaisPicConhece,
        apresentaAnsiedade:
            row['apresenta_ansiedade'].toString().toLowerCase() == 'true',
        apresentaDepressao:
            row['apresenta_depressao'].toString().toLowerCase() == 'true',
        apresentaDor: row['apresenta_dor'].toString().toLowerCase() == 'true',
        localDor: row['local_dor'],
        fumante: row['fumante'].toString().toLowerCase() == 'true',
        frequenciaFumo: row['frequencia_fumo'],
        cigarrosDia: int.parse(row['cigarros_dia'].toString()),
        fazUsoMedicamento:
            row['faz_uso_medicamento'].toString().toLowerCase() == 'true',
        medicamentos: row['medicamentos'],
      );

      listaPacientes.add(retrievedPaciente);
    }));

    return listaPacientes;
  }
}
