import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper2 {
  static const _dbName = 'contacts.db'; // Database name
  static const _dbVersion = 1; // Database version
  static const table = 'contacts'; // Table name
  static const columnId = '_id'; // Column for ID
  static const columnName = 'name'; // Column for name
  static const columnPhone = 'phone'; // Column for phone number

  // Singleton instance
  DBHelper2._privateConstructor();
  static final DBHelper2 instance = DBHelper2._privateConstructor();

  Database? _database; // To hold the database instance

  // Getter for the database
  Future<Database> get database async {
    if (_database != null)
      return _database!; // If already initialized, return it
    _database = await _initDatabase(); // Otherwise, initialize the database
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final path =
        join(await getDatabasesPath(), _dbName); // Get the database path
    return openDatabase(path,
        version: _dbVersion, onCreate: _onCreate); // Open the database
  }

  // Create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnPhone TEXT NOT NULL
    )''');
  }

  // Insert a new contact into the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row); // Insert a row into the table
  }

  // Get all contacts from the database
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(table); // Get all rows from the table
  }

  // Delete a contact from the database
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$columnId = ?', whereArgs: [id]); // Delete a row
  }
}
