import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static final String tableContato = 'contatos';
  static final String columnId = 'id';
  static final String columnNome = 'nome';
  static final String columnTelefone = 'telefone';
  static final String columnEmail = 'email';


  static final String tableLogin = 'logins';
  static final String columnUsername = 'username';
  static final String columnPassword = 'password';

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contatos.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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

    await db.execute('''
      CREATE TABLE $tableLogin (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL,
        $columnPassword TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableLogin (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnUsername TEXT NOT NULL,
          $columnPassword TEXT NOT NULL
        )
      ''');
    }
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

  static Future<int> inserirUsuario(Map<String, dynamic> usuario) async {
    final db = await getDatabase();
    return await db.insert(tableLogin, usuario);
  }

  static Future<Map<String, dynamic>?> buscarUsuario(String username, String password) async {
    final db = await getDatabase();
    final result = await db.query(
      tableLogin,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}