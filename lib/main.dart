import 'package:flutter/material.dart';
import 'package:random_note/db/diary_repository.dart';
import 'package:random_note/db/diary_service.dart';
import 'package:random_note/ui/diary_list.dart';
import 'package:intl/date_symbol_data_local.dart';

final DiaryService diaryService = DiaryService();

void main() async {
  await initializeDateFormatting('zh_CN', null);

  // 初始化本地化数据
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final DiaryRepository diaryRepository = DiaryRepository();
    // diaryRepository.clearDatabase();

    return const MaterialApp(
      title: '随心日记',
      // theme: ThemeData(
      //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: DiaryList(),
    );
  }
}
