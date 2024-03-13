// import 'Tag.dart';

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

class Diary {
  int? id; // 日记的唯一标识符
  String content; // 日记内容
  DateTime date; // 日记日期
  // List<Tag> tags; // 日记标签

  Diary({
    this.id,
    required this.content,
    required this.date,
  });

  Document get document => Document.fromJson(jsonDecode(content));

  String get plainText => document.toPlainText().replaceAll(RegExp(r'\n'), '');

  // 将日记对象转换为Map以便存储到数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  String getYearMonth() {
    return '${date.year}-${date.month}';
  }

  // 从Map中构建日记对象
  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      // tags: List<Tag>.from(map['tags'].map((tagMap) => Tag.fromMap(tagMap))), // 从Map列表构建标签List
    );
  }
}
