import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:random_note/common/datetime_helpers.dart';
import 'package:random_note/models/diary.dart';
import 'package:intl/intl.dart';
import 'package:random_note/ui/diary_edit_page.dart';

class DiaryDetailPage extends StatefulWidget {
  final Diary diary; // 可选的参数

  const DiaryDetailPage({super.key, required this.diary});

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  late Diary diary;
  late final QuillController _controller;

  void updateDiary(Diary newDiary) {
    diary = newDiary;
    _controller.document = Document.fromJson(
      jsonDecode(diary.content),
    );
  }

  @override
  void initState() {
    super.initState();
    diary = widget.diary;
    _controller = QuillController(
        document: Document.fromJson(jsonDecode(diary.content)),
        selection: const TextSelection.collapsed(offset: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 80,
                          child: Container(
                            margin: const EdgeInsets.only(right: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  diary.date.day.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('MMMM', 'zh_CN')
                                      .format(diary.date), // 获取月份并格式化为中文
                                  style: const TextStyle(letterSpacing: 7),
                                ),
                                const Divider(color: Colors.black),
                                Text(
                                  '${DatetimeStringify(diary.date).yearString}年',
                                  style: const TextStyle(letterSpacing: 7),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 8), // 调整底部间距
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.black)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(diary.date),
                                  style: const TextStyle(
                                      fontSize: 13, height: 1.5),
                                ),
                                const Divider(color: Colors.black),
                                Text(
                                  DateFormat('EEE', "zh_CN").format(diary.date),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        controller: _controller,
                        padding: const EdgeInsets.all(16),
                        readOnly: true,
                        showCursor: false,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            // 底部按钮
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // 返回按钮的操作
                      Navigator.pop(context);
                    },
                  ),
                  // TODO 分享
                  // IconButton(
                  //   icon: Icon(Icons.share),
                  //   onPressed: () {
                  //     // 分享按钮的操作
                  //     // 这里可以添加分享逻辑
                  //   },
                  // ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      // 编辑按钮的操作
                      // 这里可以添加编辑逻辑
                      // 跳转到编辑页面
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiaryEditPage(
                                  initialDiary: diary,
                                )),
                      );
                      if (result != null) {
                        setState(() {
                          updateDiary(result);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
