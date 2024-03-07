import 'package:random_note/models/diary.dart';

import 'database_helper.dart';

class DiaryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> insertDiary(Diary diary) async {
    await _databaseHelper.insertDiary(diary);
  }

  Future<void> updateDiary(Diary diary) async {
    await _databaseHelper.updateDiary(diary);
  }

  Future<void> deleteDiary(int id) async {
    await _databaseHelper.deleteDiary(id);
  }

  Future<List<Diary>> getAllDiaries() async {
    return await _databaseHelper.getAllDiaries();
  }

  Future<int> clearDatabase() async {
    return await _databaseHelper.clearDatabase();
  }
}
