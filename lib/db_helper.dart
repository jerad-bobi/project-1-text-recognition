import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    return openDatabase(
      'app.db', // Your app's database name (change it if necessary)
      version: 1,
      onCreate: (db, version) async {
        // Create the 'products' table
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            expiryDate TEXT,
            category TEXT,
            description TEXT,
            quantity INTEGER,
            image TEXT
          )
        ''');

        // Create the 'reminders' table
        await db.execute('''
          CREATE TABLE reminders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            date TEXT,
            time TEXT,
            location TEXT,
            description TEXT,
            notes TEXT
          )
        ''');

        // Create the 'contacts' table (Modified)
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT,
            address TEXT -- Removed email and kept address field
          )
        ''');
      },
    );
  }

  // Insert a new product into the database
  static Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database();
    await db.insert(
      'products',
      product,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update a product in the database
  static Future<void> updateProduct(Map<String, dynamic> product) async {
    final db = await database();
    await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  // Fetch all products from the database
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final db = await database();
    return db.query('products');
  }

  // Delete a product from the database by its ID
  static Future<void> deleteProduct(int productId) async {
    final db = await database();
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // Insert a new reminder into the database
  static Future<void> insertReminder(Map<String, dynamic> reminder) async {
    final db = await database();
    await db.insert(
      'reminders',
      reminder,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update a reminder in the database
  static Future<void> updateReminder(Map<String, dynamic> reminder) async {
    final db = await database();
    await db.update(
      'reminders',
      reminder,
      where: 'id = ?',
      whereArgs: [reminder['id']],
    );
  }

  // Delete a reminder from the database by its ID
  static Future<void> deleteReminder(int reminderId) async {
    final db = await database();
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [reminderId],
    );
  }

  // Fetch all reminders from the database
  static Future<List<Map<String, dynamic>>> fetchReminders() async {
    final db = await database();
    return db.query('reminders');
  }

  // Fetch reminders for a specific date
  static Future<List<Map<String, dynamic>>> fetchRemindersForDate(
      String date) async {
    final db = await database();
    return db.query(
      'reminders',
      where: 'date = ?',
      whereArgs: [date],
    );
  }
}
