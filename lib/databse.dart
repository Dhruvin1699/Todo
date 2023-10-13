import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _singleton = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _singleton;
  }

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _singleton;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    // print('Initializing database...');
    String path = join(await getDatabasesPath(), 'tasks.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );


    // Insert default categories when the database is initialized


  return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task TEXT,
      date TEXT,  
      selectedItem TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
  ''');
  }


  Future<void> insertTask(String task, String date, String selectedItem) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'task': task,
        'date': date,
        'selectedItem': selectedItem,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return TaskModel(
        id: maps[i]['id'],
        task: maps[i]['task'],
        date: maps[i]['date'],
        selectedItem: maps[i]['selectedItem'],
      );
    });
  }
  Future<void> updateTask(TaskModel updatedTask) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'tasks',
      updatedTask.toMap(),
      where: "id = ?",
      whereArgs: [updatedTask.id],
    );
  }
  Future<void> deleteTask(int taskId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'tasks',

      where: "id = ?",
      whereArgs: [taskId],
    );
    print('Task deleted: $taskId');
  }


  Future<List<String>> getCategories() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }
  // Insert default categories if they don't exist
  Future<void> insertDefaultCategories() async {
    final db = await database;
     List<String> defaultCategories = [];

    defaultCategories.forEach((category) async {
      await db.insert(
        'categories',
        {'name': category},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    });
  }
  Future<void> insertCategory(String category) async {
    final Database db = await database;
    await db.insert('categories', {'name': category});
  }
  Future<void> updateCategory(String oldCategory, String newCategory) async {
    final db = await database;
    await db.update(
      'categories',
      {'name': newCategory},
      where: "name = ?",
      whereArgs: [oldCategory],
    );
  }
  Future<void> saveTask(TaskModel task) async {
    final db = await database;
    if (task.id == 0) {
      await db.insert(
        'tasks',
        {
          'task': task.task,
          'date': task.date,
          'selectedItem': task.selectedItem,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(
        'tasks',
        task.toMap(),
        where: "id = ?",
        whereArgs: [task.id],
      );
    }
  }
}
class TaskModel {
  final int id;
  final String task;
  final String date;
  late final String selectedItem;

  TaskModel({
    required this.id,
    required this.task,
    required this.date,
    required this.selectedItem,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'date': date,
      'selectedItem': selectedItem,
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      task: map['task'],
      date: map['date'],
      selectedItem: map['selectedItem'],
    );
  }


  Future<void> updateTask() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'tasks',
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}



// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper _singleton = DatabaseHelper._internal();
//   static Database? _database;
//
//   factory DatabaseHelper() {
//     return _singleton;
//   }
//
//   DatabaseHelper._internal();
//
//   static DatabaseHelper get instance => _singleton;
//
//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     } else {
//       _database = await _initDatabase();
//       return _database!;
//     }
//   }
//
//   Future<Database> _initDatabase() async {
//     // print('Initializing database...');
//     String path = join(await getDatabasesPath(), 'tasks.db');
//     Database db = await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//
//
//     // Insert default categories when the database is initialized
//
//
//     return db;
//   }
//
//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE tasks(
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       task TEXT,
//       date TEXT,  -- Make sure 'date' column is defined here
//       selectedItem TEXT
//     )
//   ''');
//     await db.execute('''
//     CREATE TABLE categories(
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       name TEXT
//     )
//   ''');
//   }
//
//
//   Future<void> insertTask(String task, String date, String selectedItem) async {
//     final db = await database;
//     await db.insert(
//       'tasks',
//       {
//         'task': task,
//         'date': date,
//         'selectedItem': selectedItem,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<List<TaskModel>> getTasks() async {
//     final db = await database;
//     List<Map<String, dynamic>> maps = await db.query('tasks');
//     return List.generate(maps.length, (i) {
//       return TaskModel(
//         id: maps[i]['id'],
//         task: maps[i]['task'],
//         date: maps[i]['date'],
//         selectedItem: maps[i]['selectedItem'],
//       );
//     });
//   }
//
//   Future<void> deleteTask(int taskId) async {
//     final db = await DatabaseHelper.instance.database;
//     await db.delete(
//       'tasks',
//
//       where: "id = ?",
//       whereArgs: [taskId],
//     );
//     print('Task deleted: $taskId');
//   }
//
//   Future<List<String>> getCategories() async {
//     final db = await database;
//     List<Map<String, dynamic>> maps = await db.query('categories');
//     return List.generate(maps.length, (i) {
//       return maps[i]['name'];
//     });
//   }
//
//   // Insert default categories if they don't exist
//   Future<void> insertDefaultCategories() async {
//     final db = await database;
//     List<String> defaultCategories = ['Default Category 1', 'Default Category 2', 'Default Category 3'];
//
//     defaultCategories.forEach((category) async {
//       await db.insert(
//         'categories',
//         {'name': category},
//         conflictAlgorithm: ConflictAlgorithm.ignore,
//       );
//     });
//   }
//   Future<void> insertCategory(String category) async {
//     final Database db = await database;
//     await db.insert('categories', {'name': category});
//   }
//
//
// }
// class TaskModel {
//   final int id;
//   final String task;
//   final String date;
//   late final String selectedItem;
//
//   TaskModel({
//     required this.id,
//     required this.task,
//     required this.date,
//     required this.selectedItem,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'task': task,
//       'date': date,
//       'selectedItem': selectedItem,
//     };
//   }
//
//   static TaskModel fromMap(Map<String, dynamic> map) {
//     return TaskModel(
//       id: map['id'],
//       task: map['task'],
//       date: map['date'],
//       selectedItem: map['selectedItem'],
//     );
//   }
//
//   Future<void> updateTask() async {
//     final db = await DatabaseHelper.instance.database;
//     await db.update(
//       'tasks',
//       toMap(),
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
// }
//
//

