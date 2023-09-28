import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
          CREATE TABLE Todo (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            todo text,
            done INTEGER DEFAULT 0
          )
""");
  }

  static Future<sql.Database> db() async {
    print('db');
    return sql.openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async => await createTables(db),
    );
  }

  static Future<int> createItem(String todo) async {
    final db = await SQLHelper.db();
    final data = {'todo': todo};
    print('data,$data');
    final id = await db.insert(
      'Todo',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('Todo', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('Todo', where: 'id = ?', limit: 1, whereArgs: [id]);
  }

  static Future toggleTodoItem(int id) async {
    final db = await SQLHelper.db();
    final query = await SQLHelper.getItem(id);

    // toggle code

    final newValue = query[0]['done'] == 0 ? 1 : 0;

    await db.update('Todo', {'done': newValue},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future deleteItem(int id) async {
    final db = await SQLHelper.db();
    await db.delete('Todo', where: 'id = ?', whereArgs: [id]);
  }

  static Future deleteAllItems() async {
    final db = await SQLHelper.db();
    await db.delete('Todo');
  }

  static Future searchBy(String? searchTxt) async {
    searchTxt ??= ' ';
    final db = await SQLHelper.db();
    final qs = await db
        .query('Todo', where: 'todo LIKE ?', whereArgs: ['%$searchTxt%']);
    return qs;
  }
}
