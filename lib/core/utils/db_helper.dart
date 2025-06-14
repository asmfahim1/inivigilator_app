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

  // Static instance, initialized once and shared across the entire app
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor returns the same instance every time
  factory DatabaseHelper() => _instance;

  // Private constructor, so no one can instantiate DatabaseHelper directly
  DatabaseHelper._internal();

  static Database? _db;

  // Method to access the database
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return _db = await openDatabase(
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
        $studentId INTEGER,
        $student_name TEXT,
        $columnEmbedding TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $attendanceRecordTable (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $studentId INTEGER,
        $student_name TEXT,
        distance REAL,
        timestamp TEXT
      )
    ''');
  }

  //insert
  Future<int> insert(Map<String, dynamic> row) async {
    return await _db!.insert(tableName, row);
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    return await _db!.insert(tableName, student);
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    return await _db!.query(tableName);
  }

  // unique students
  Future<List<Map<String, dynamic>>> getUniqueStudents() async {
    return await _db!.rawQuery('''
    SELECT DISTINCT $studentId, $student_name 
    FROM $tableName
  ''');
  }

  Future<int> clearDatabase() async {
    return await _db!.delete(tableName);
  }

  Future<bool> hasStudents() async {
    var result = await _db!.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result)!;
    return count > 0;
  }


  //get all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db!.query(tableName);
  }

  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db!.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(results) ?? 0;
  }


  Future<bool> isNameAlreadyPresent(String name, int studentId) async {
    var result = await _db!.query(
      attendanceRecordTable,
      where: 'name = ? AND studentId = ?',
      whereArgs: [name, studentId],
    );
    return result.isNotEmpty;
  }


  Future<int> insertAttendanceRecord(Map<String, dynamic> record) async {
    if (record['name'] == 'Unknown') {
      return -1;
    } else {
      return await _db!.insert(attendanceRecordTable, record);
    }
  }

  Future<List<Map<String, dynamic>>> getAllAttendedStudent() async {
    return await _db!.query(attendanceRecordTable);
  }

  Future<int> clearAttendanceTable() async {
    return await _db!.delete(attendanceRecordTable);
  }
}