import 'dart:async';

import 'package:random_note/db/diary_repository.dart';
import 'package:random_note/models/diary.dart';

class DiaryService {
  DiaryService() {
    getAllDiaries().then((value) {
      _diaryStreamController.add(value);
    });
  }
  final StreamController<List<Diary>> _diaryStreamController =
      StreamController<List<Diary>>.broadcast();

  Stream<List<Diary>> get diaryStream => _diaryStreamController.stream;
  final DiaryRepository diaryRepository = DiaryRepository();

  // 添加日记
  Future<void> insertDiary(Diary newDiary) async {
    // 保存日记到数据库或其他数据源
    await diaryRepository.insertDiary(newDiary);
    // 发送更新的日记列表到流
    _diaryStreamController.add(await getAllDiaries());
  }

  void deleteDiary(int id) async {
    diaryRepository.deleteDiary(id);
    _diaryStreamController.add(await getAllDiaries());
  }

  // 获取所有日记
  Future<List<Diary>> getAllDiaries() async {
    return await diaryRepository.getAllDiaries();
  }

  Future<void> updateDiary(Diary diary) async {
    await diaryRepository.updateDiary(diary);
    _diaryStreamController.add(await getAllDiaries());
  }

  // 关闭流
  void dispose() {
    _diaryStreamController.close();
  }
}
