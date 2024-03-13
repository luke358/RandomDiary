import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:random_note/db/diary_repository.dart';
import 'package:random_note/main.dart';
import 'package:random_note/models/diary.dart';
import 'package:random_note/widgets/date_time_picker_sheet.dart';
import 'package:unicons/unicons.dart';

class DiaryEditPage extends StatefulWidget {
  final Diary? initialDiary; // 可选的参数

  const DiaryEditPage({super.key, this.initialDiary});

  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  late final QuillController _controller;

  final DiaryRepository diaryRepository = DiaryRepository();

  late DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDiary?.date ?? DateTime.now();
    // 初始化 QuillController
    _controller = widget.initialDiary != null
        ? QuillController(
            document:
                Document.fromJson(jsonDecode(widget.initialDiary!.content)),
            selection: const TextSelection.collapsed(offset: 0),
          )
        : QuillController.basic();
  }

  void onDateChange(DateTime date) {
    selectedDate = date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 150,
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('yyyy/MM/dd HH:mm').format(selectedDate),
                  style: const TextStyle(fontSize: 14, height: 2.5),
                ),
                const Icon(UniconsLine.angle_up),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DateTimePickerSheet(
                    selectedDate: selectedDate,
                    onSelected: (date) => {
                      setState(() {
                        selectedDate = date;
                      })
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Save the diary content
              String content =
                  jsonEncode(_controller.document.toDelta().toJson());

              final Diary newDiary =
                  Diary(content: content, date: selectedDate);
              if (widget.initialDiary != null) {
                newDiary.id = widget.initialDiary!.id;
                await diaryService.updateDiary(newDiary);
              } else {
                await diaryService.insertDiary(newDiary);
              }
              // ignore: use_build_context_synchronously
              if (mounted) Navigator.pop(context, newDiary);
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
