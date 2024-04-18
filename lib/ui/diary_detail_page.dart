import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  late FToast fToast;

  void updateDiary(Diary newDiary) {
    diary = newDiary;
    _controller.document = Document.fromJson(
      jsonDecode(diary.content),
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast.init(context);

    diary = widget.diary;
    _controller = QuillController(
        document: Document.fromJson(jsonDecode(diary.content)),
        selection: const TextSelection.collapsed(offset: 0));
  }

  Widget _buildHeaderLeft() {
    return Expanded(
      flex: 80,
      child: Container(
        margin: const EdgeInsets.only(right: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diary.date.day.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('MMMM', 'zh_CN').format(diary.date), // 获取月份并格式化为中文
              style: const TextStyle(letterSpacing: 7, fontSize: 18),
            ),
            const Divider(color: Colors.black),
            Text(
              '${DatetimeStringify(diary.date).yearString}年',
              style: const TextStyle(letterSpacing: 7, fontSize: 18),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8), // 调整底部间距
              child: const Divider(
                color: Colors.black,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRight() {
    return Expanded(
      flex: 15,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        height: 100,
        decoration:
            BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat('HH:mm').format(diary.date),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const Divider(color: Colors.black),
            Text(
              DateFormat('EEE', "zh_CN").format(diary.date),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [_buildHeaderLeft(), _buildHeaderRight()],
    );
  }

  Widget _buildButtons() {
    return SizedBox(
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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 分享按钮的操作
              // 这里可以添加分享逻辑

              fToast.showToast(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.greenAccent,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(Icons.warning_amber_outlined),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text("敬请期待～"),
                      ],
                    )),
                gravity: ToastGravity.TOP, // 设置显示位置R
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // 编辑按钮的操作
              // 这里可以添加编辑逻辑
              // 跳转到编辑页面
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        controller: _controller,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        readOnly: true,
                        showCursor: false,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            // 底部按钮
            _buildButtons()
          ],
        ),
      ),
    );
  }
}
