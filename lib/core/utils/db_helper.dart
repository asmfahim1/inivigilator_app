import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'student_table';

  static const columnId = 'id';
  static const studentId = 'student_id';
  static const student_name = 'student_name';
  static const columnEmbedding = 'face_vector';
  static const exam_id = 'exam_id';
  static const exam_name = 'exam_name';
  static const created_at = 'created_at';
  static const updated_at = 'updated_at';

  late Database _db;


  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $studentId TEXT,
        $student_name TEXT,
        $exam_id TEXT,
        $exam_name TEXT,
        $columnEmbedding TEXT,
        $created_at TEXT,
        $updated_at TEXT
      )
    ''');
  }

  //insert
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<void> insertStudent(Map<String, dynamic> student) async {
    // final db = _db;
    await _db.insert(
      'students',
      student,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    // final db = await database;
    return await _db.query('students');
  }


  //get all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<void> clearDatabase() async {
    await _db.delete('students');
  }

  Future<bool> hasStudents() async {
    //final db = await database;
    final count = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM students'));
    return count! > 0;
  }
}