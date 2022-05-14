import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_facchi/models/task_model.dart';

class DBProvider{
  DBProvider._init();
  static final DBProvider dataBase = DBProvider._init();
  static Database? _database;

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await initDataBase();
    return _database!;
  }

  initDataBase() async{
    return await openDatabase(
      join(await getDatabasesPath(), 'todo_app_db.db'),
      onCreate: (db, version) async{
        await db.execute('''
        CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creationDate TEXT)
        ''');
      },
      version: 1
    );
  }

  addNewTask(Task newTask) async{
    final db = await database;
    db.insert("tasks", newTask.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteTask(int id) async{
    final db = await database;
    return await db.rawDelete('DELETE FROM tasks WHERE id = ?',[id],);

  }

  Future<dynamic> getTask() async{
    final db = await database;
    var res = await db.query("tasks");
    if(res.length == 0){
      return Null;
    }else{
      var resultMap = res.toList();
      return resultMap.isNotEmpty? resultMap: Null;
    }
  }

}

