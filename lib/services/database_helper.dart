// File: lib/services/database_helper.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qualis/model/qualificacao.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "qualis.db";
  static const _databaseVersion = 1;

  static const table = 'qualificacoes';

  static const columnId = 'id';
  static const columnType = 'type';
  static const columnDescription = 'description';
  static const columnSigla = 'sigla';
  static const columnQuarto= 'quarto';
  static const columnQuinto = 'quinto';


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Delete the database
    // if (await databaseExists(path)) {
    //   await deleteDatabase(path);
    // }
    // Open the database
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''
          CREATE TABLE $table (
            $columnId TEXT  NOT NULL,
            $columnType TEXT  NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnSigla TEXT NOT NULL,
            $columnQuarto TEXT,
            $columnQuinto TEXT,
            PRIMARY KEY ($columnId, $columnType)
          )
          ''');
    await db.execute('CREATE INDEX idx_id ON $table ($columnId)');
    await db.execute('CREATE INDEX idx_id_type ON $table ($columnId,$columnType)');
    await db.execute('CREATE INDEX idx_type ON $table ($columnType)');
    await db.execute('CREATE INDEX idx_sigla ON $table ($columnSigla)');
  }

  Future<void> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    var res = await db.query(table,
        where: '$columnId = ? AND $columnType = ?',
        whereArgs: [row[columnId], row[columnType]]);
    if (res.isEmpty) {
      await db.insert(table, row);
    } else {}
  }

  Future<List<Qualificacao>> queryAllRows(String type) async {
    Database db = await instance.database;
    final maps =
        await db.query(table, where: '$columnType = ?', whereArgs: [type]);

    return List.generate(maps.length, (i) {
      return Qualificacao.fromMap(maps[i]);
    });
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update(table, row,
        where: '$columnId = ?', whereArgs: [row[columnId], row[columnType]]);
  }

  Future<int> delete(String id, String type) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$columnId = ?', whereArgs: [id, type]);
  }
}
