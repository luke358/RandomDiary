// import 'Tag.dart';

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:random_note/common/datetime_helpers.dart';

class Diary {
  int? id; // 日记的唯一标识符
  String content; // 日记内容
  DateTime date; // 日记日期
  String mode; // 日期类型
  // List<Tag> tags; // 日记标签

  Diary({
    this.id,
    required this.content,
    required this.date,
    this.mode = 'richtext',
  });

  Document get document => Document.fromJson(jsonDecode(content));

  String get plainText => mode == 'richtext'
      ? document.toPlainText().replaceAll(RegExp(r'\n'), '')
      : content;

  // 将日记对象转换为Map以便存储到数据库
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'mode': mode,
    };
  }

  String getYearMonth() {
    return '${DatetimeStringify(date).yearString}年 ${DateFormat('MMMM', 'zh_CN').format(date)}'; // 获取月份并格式化为中文
  }

  String group() => '${date.year}${date.month}';

  // 从Map中构建日记对象
  factory Diary.fromMap(Map<String, dynamic> map) {
    print(map);
    return Diary(
      id: map['id'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mode: map['mode']
      // tags: List<Tag>.from(map['tags'].map((tagMap) => Tag.fromMap(tagMap))), // 从Map列表构建标签List
    );
  }
}
