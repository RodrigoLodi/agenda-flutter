import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static final String tableContato = 'contatos';
  static final String columnId = 'id';
  static final String columnNome = 'nome';
  static final String columnTelefone = 'telefone';
  static final String columnEmail = 'email';

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contatos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableContato (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNome TEXT NOT NULL,
        $columnTelefone TEXT NOT NULL,
        $columnEmail TEXT NOT NULL
      )
    ''');
  }

  static Future<int> inserirContato(Map<String, dynamic> contato) async {
    final db = await getDatabase();
    return await db.insert(tableContato, contato);
  }

  static Future<List<Map<String, dynamic>>> buscarContatos() async {
    final db = await getDatabase();
    return await db.query(tableContato);
  }

  static Future<int> atualizarContato(Map<String, dynamic> contato) async {
    final db = await getDatabase();
    return await db.update(
      tableContato,
      contato,
      where: '$columnId = ?',
      whereArgs: [contato[columnId]],
    );
  }

  static Future<int> deletarContato(int id) async {
    final db = await getDatabase();
    return await db.delete(
      tableContato,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
