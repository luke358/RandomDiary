import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:random_note/db/diary_repository.dart';
import 'package:random_note/main.dart';
import 'package:random_note/models/diary.dart';
import 'package:random_note/widgets/date_time_picker_sheet.dart';
import 'package:unicons/unicons.dart';

enum ToolbarState {
  keyboardActive,
  keyboardHide,
  textActive,
  imageActive,
  pagerActive,
  finishActive
}

class DiaryEditTextPage extends StatefulWidget {
  final Diary? initialDiary; // 可选的参数

  const DiaryEditTextPage({super.key, this.initialDiary});

  @override
  State<DiaryEditTextPage> createState() => _DiaryEditTextPageState();
}

class _DiaryEditTextPageState extends State<DiaryEditTextPage>
    with WidgetsBindingObserver {
  final DiaryRepository diaryRepository = DiaryRepository();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late DateTime selectedDate = DateTime.now();

  late StreamSubscription<bool> keyboardSubscription;
  late ToolbarState toolbarActive = ToolbarState.keyboardActive;

  double keyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDiary?.date ?? DateTime.now();

    _controller.text = widget.initialDiary?.content ?? '';
    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        setState(() {
          toolbarActive = ToolbarState.keyboardActive;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
    keyboardSubscription.cancel();
  }

  void onDateChange(DateTime date) {
    selectedDate = date;
  }

  Future<void> saveDiary() async {
    String content = _controller.text;
    final Diary newDiary =
        Diary(content: content, date: selectedDate, mode: 'text');
    if (widget.initialDiary != null) {
      newDiary.id = widget.initialDiary!.id;
      await diaryService.updateDiary(newDiary);
    } else {
      await diaryService.insertDiary(newDiary);
    }
    // ignore: use_build_context_synchronously
    if (mounted) Navigator.pop(context, newDiary);
  }

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.black38, // 设置边框颜色
          width: 0.1, // 设置边框宽度
        ),
      ),
      title: SizedBox(
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('yyyy/MM/dd HH:mm').format(selectedDate),
                style: const TextStyle(fontSize: 18, height: 2.5),
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
          onPressed: saveDiary,
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey.shade200, width: 0.4),
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: toolbarActive == ToolbarState.keyboardHide ? pi : 0,
            child: IconButton(
                onPressed: () {
                  if (toolbarActive == ToolbarState.keyboardActive) {
                    setState(() {
                      toolbarActive = ToolbarState.keyboardHide;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                  } else {
                    FocusScope.of(context).requestFocus(_focusNode);
                    setState(() {
                      toolbarActive = ToolbarState.keyboardActive;
                    });
                  }
                },
                icon: Icon(
                  Icons.keyboard_hide_outlined,
                  size: 28,
                  color: toolbarActive == ToolbarState.keyboardActive
                      ? Colors.blueAccent
                      : null,
                )),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  toolbarActive = ToolbarState.textActive;
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
              icon: Icon(
                Icons.text_fields_outlined,
                size: 28,
                color: toolbarActive == ToolbarState.textActive
                    ? Colors.blueAccent
                    : null,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.image_outlined,
                size: 28,
              )),
          IconButton(
            onPressed: () {
              setState(() {
                toolbarActive = ToolbarState.pagerActive;
              });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            icon: Icon(
              Icons.menu_book_outlined,
              size: 28,
              color: toolbarActive == ToolbarState.pagerActive
                  ? Colors.blueAccent
                  : null,
            ),
          ),
          IconButton(
            onPressed: saveDiary,
            icon: Icon(
              Icons.menu_book_outlined,
              size: 28,
              color: toolbarActive == ToolbarState.pagerActive
                  ? Colors.blueAccent
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      keyboardHeight =
          max(MediaQuery.of(context).viewInsets.bottom, keyboardHeight);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                maxLines: null, // 设置为允许多行输入
                decoration: const InputDecoration(
                  border: InputBorder.none, // 去掉底部的线条
                ),
              ),
            ),
          ),
          _buildToolbar(),
          Container(
            height:
                toolbarActive == ToolbarState.keyboardHide ? 0 : keyboardHeight,
          )
        ],
      ),
    );
  }
}
