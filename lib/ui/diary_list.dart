import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_note/main.dart';
import 'package:random_note/models/diary.dart';
import 'package:random_note/ui/diary_detail_page.dart';
import 'package:random_note/ui/diary_edit_page.dart';
import 'package:unicons/unicons.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MaterialApp(
    home: DiaryList(),
  ));
}

class DiaryList extends StatefulWidget {
  const DiaryList({super.key});

  @override
  _DiaryListState createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  @override
  void initState() {
    super.initState();
  }

  void toAddDiaryPage() {
    // 跳转到新增页面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DiaryEditPage()),
    );
  }

  Widget _getBodyBySnapshotState(
    BuildContext context,
    AsyncSnapshot<List<Diary>> snapshot,
  ) {
    if (snapshot.hasError) {
      return Center(child: Text('Steam error: ${snapshot.error}'));
    }
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return const Center(child: Icon(UniconsLine.data_sharing));
      case ConnectionState.waiting:
        return const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('加载中...')],
          ),
        );
      case ConnectionState.active:
        final diaries = snapshot.data!;
        final sections = groupBy(diaries, (diary) => diary.getYearMonth());
        final formattedSections = sections.entries.map((entry) {
          final header = entry.key;

          return _DiaryListViewSection(
            header: header,
            items: entry.value.toList(),
          );
        }).toList();
        return ListView.builder(
          itemCount: formattedSections.length,
          itemBuilder: (BuildContext context, int index) {
            final section = formattedSections[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Container(
                        height: 228,
                        padding: const EdgeInsets.only(top: 20.0),
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text(
                              DateTime.now().day.toString().padLeft(2, '0'),
                              style: TextStyle(fontSize: 50),
                            ),
                            Text('三月 ｜ 周五'),
                            Text('一段经典的名言，一段静单的名言。。。。。。。')
                          ],
                        ))
                    : Container(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '◆ ${section.header} ◆',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 169, 169, 169),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: section.items
                      .map((item) => Container(
                            margin: const EdgeInsets.only(
                                bottom: 8.0, left: 10.0, right: 10.0), // 设置底部间距
                            color: Colors.white, // 设置日记项的背景为白色
                            child: DiaryListItem(diary: item),
                          ))
                      .toList(),
                ),
              ],
            );
          },
        );
      case ConnectionState.done:
        return const Center(child: Text('Stream closed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xf7f7f7f7),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          StreamBuilder(
            stream: diaryService.diaryStream,
            builder: _getBodyBySnapshotState,
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      toAddDiaryPage();
                    },
                  )
                ],
              )),
        ],
      ),
    ));
  }
}

class DiaryListItem extends StatelessWidget {
  final Diary diary;

  const DiaryListItem({super.key, required this.diary});

  Future<bool> confirmDismiss(String text) async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(diary.id.toString()), // 唯一标识，通常是数据的唯一标识
        background: Container(
          color: Colors.red, // 滑动时显示的背景颜色
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (direction) => confirmDismiss(diary.id.toString()),
        onDismissed: (_) => {print(_)},
        movementDuration: const Duration(milliseconds: 400),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 50), () {
                    // 在延迟后执行点击事件
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryDetailPage(diary: diary),
                      ),
                    );
                  });
                },
                child: Ink(
                    color: Colors.white,
                    child: Container(
                      height: 98,
                      padding: const EdgeInsets.only(
                          top: 12.0, right: 20.0, bottom: 12.0),
                      child: Row(
                        children: [
                          // 左边布局
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 1))),
                            width: 55.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${diary.date.day}'.padLeft(2, '0'),
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat('EEE', "zh_CN").format(diary.date),
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      height: 1.5,
                                      color:
                                          Color.fromARGB(255, 113, 113, 113)),
                                ),
                                Text(
                                    '${'${diary.date.hour}'.padLeft(2, '0')}:${'${diary.date.minute}'.padLeft(2, '0')}',
                                    style: const TextStyle(
                                        fontSize: 10.0,
                                        color:
                                            Color.fromARGB(255, 168, 168, 168)))
                              ],
                            ),
                          ),
                          // 右边布局
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 7, bottom: 7),
                                  child: Text(
                                    // _truncateContent(diary.plainText),
                                    diary.plainText,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )))));
  }
}

class _DiaryListViewSection {
  late String header;
  late List<Diary> items;

  _DiaryListViewSection({
    required this.header,
    required this.items,
  });
}
