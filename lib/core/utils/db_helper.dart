import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const tableName = 'student_table';
  static const attendanceRecordTable = 'attendance_record_table';

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
      CREATE TABLE $tableName (
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
    await db.execute('''
      CREATE TABLE $attendanceRecordTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        distance REAL,
        timestamp TEXT
      )
    ''');
  }

  //insert
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(tableName, row);
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    //var dbClient = await db;
    return await _db.insert(tableName, student);
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    //var dbClient = await db;
    return await _db.query(tableName);
  }

  Future<int> clearDatabase() async {
    //var dbClient = await db;
    return await _db.delete(tableName);
  }

  Future<bool> hasStudents() async {
    //var dbClient = await db;
    var result = await _db.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result)!;
    return count > 0;
  }


  //get all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(tableName);
  }

  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(results) ?? 0;
  }


  Future<bool> isNameAlreadyPresent(String name) async {
    var result = await _db.query(
      attendanceRecordTable,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }


  Future<int> insertAttendanceRecord(Map<String, dynamic> record) async {
    if (record['name'] == 'Unknown') {
      return -1; // Return a value indicating failure or handle appropriately
    } else {
      return await _db.insert(attendanceRecordTable, record);
    }
  }

  Future<List<Map<String, dynamic>>> getAllAttendedStudent() async {
    return await _db.query(attendanceRecordTable);
  }
}