import 'package:random_note/models/diary.dart';
import 'package:random_note/models/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'diary_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT,
        tags TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tags(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
        CREATE TABLE diary_tags(
          diary_id INTEGER,
          tag_id INTEGER,
          FOREIGN KEY(diary_id) REFERENCES diary(id),
          FOREIGN KEY(tag_id) REFERENCES tags(id),
          PRIMARY KEY (diary_id, tag_id)
        )
      ''');
  }

  Future<int> insertTag(Tag tag) async {
    final Database db = await instance.database;

    // 插入标签
    int tagId = await db.insert('tags', {
      'name': tag.name,
    });

    return tagId;
  }

  // 添加插入、更新、删除和查询日记的方法
  Future<int> insertDiary(Diary diary) async {
    final Database db = await instance.database;

    // 插入日记
    int diaryId = await db.insert('diary', {
      'content': diary.content,
      'date': diary.date.toIso8601String(),
    });

    // 返回日记的ID
    return diaryId;
  }

  Future<void> updateDiary(Diary diary) async {
    final Database db = await instance.database;
    await db
        .update('diary', diary.toMap(), where: 'id = ?', whereArgs: [diary.id]);
  }

  Future<void> deleteDiary(int id) async {
    final Database db = await instance.database;
    await db.delete('diary', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Diary>> getAllDiaries() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('diary', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      print(Diary.fromMap(maps[i]).date);
      return Diary.fromMap(maps[i]);
    });
  }

  Future<int> clearDatabase() async {
    final Database db = await instance.database;

    // 获取数据库中的所有表
    List<String> tables = await db
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']).then(
            (result) => result.map((row) => row['name'] as String).toList());

    // 删除每个表中的所有数据
    for (String table in tables) {
      await db.delete(table);
    }
    return tables.length;
  }
}
