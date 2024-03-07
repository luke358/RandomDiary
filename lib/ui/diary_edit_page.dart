import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:random_note/db/diary_repository.dart';
import 'package:random_note/models/diary.dart';

class DiaryEditPage extends StatefulWidget {
  final Diary? initialDiary; // 可选的参数

  const DiaryEditPage({Key? key, this.initialDiary}) : super(key: key);

  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  late final QuillController _controller;

  final DiaryRepository diaryRepository = DiaryRepository();

  @override
  void initState() {
    super.initState();
    // 初始化 QuillController
    _controller = widget.initialDiary != null
        ? QuillController(
            document:
                Document.fromJson(jsonDecode(widget.initialDiary!.content)),
            selection: const TextSelection.collapsed(offset: 0),
          )
        : QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Diary'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the diary content
              String content =
                  jsonEncode(_controller.document.toDelta().toJson());

              if (widget.initialDiary != null) {
                diaryRepository.updateDiary(Diary(
                  id: widget.initialDiary!.id,
                  content: content,
                  date: DateTime.now(),
                ));
              } else {
                diaryRepository.insertDiary(Diary(
                  content: content,
                  date: DateTime.now(),
                ));
              }
              Navigator.pop(context, content);

              // Perform your save logic here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          QuillToolbar.simple(
            configurations:
                QuillSimpleToolbarConfigurations(controller: _controller),
          ),
        ],
      ),
    );
  }
}
