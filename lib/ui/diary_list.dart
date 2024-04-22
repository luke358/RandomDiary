import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:random_note/main.dart';
import 'package:random_note/models/diary.dart';
import 'package:random_note/ui/diary_detail_page.dart';
import 'package:random_note/ui/diary_edit_page_text.dart';
import 'package:random_note/ui/setting_drawer.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:unicons/unicons.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = ExpandableListController();
  late List<_DiaryListViewSection> _sections = [];

  int stickySectionIndex = -1;

  @override
  void initState() {
    super.initState();

    diaryService.diaryStream.listen((diaries) {
      final sections = groupBy(diaries, (diary) => diary.getYearMonth())
          .entries
          .map((entry) {
        final header = entry.key;
        return _DiaryListViewSection(
          header: header,
          items: entry.value.toList(),
        );
      }).toList();
      setState(() {
        _sections = sections; // 将数据保存到变量中
      });
    });

    _controller.addListener(() {
      // print("switchingSectionIndex:${_controller.switchingSectionIndex}, stickySectionIndex:" +
      //     "${_controller.stickySectionIndex},scrollPercent:${_controller.percent}");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          stickySectionIndex = _controller.stickySectionIndex;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void toAddDiaryPage() {
    // 跳转到新增页面
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const DiaryEditTextPage()),
    );
  }

  Widget _buildListHeader() {
    return Container(
        height: 220,
        padding: const EdgeInsets.only(top: 30.0, left: 50, right: 50),
        margin: const EdgeInsets.only(bottom: 8.0),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  DateTime.now().day.toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 50),
                )),
            Container(
              alignment: Alignment.center,
              child: Text(
                  '${DateFormat('MMMM', 'zh_CN').format(DateTime.now())} ｜ ${DateFormat('EEE', "zh_CN").format(DateTime.now())}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13)),
            ),
            const Divider(thickness: 0.5, height: 35),
            const Text('一段经典的名言，一段静单的名言。。。。。。。',
                textAlign: TextAlign.left, style: TextStyle(fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 0.1,
                  width: 25,
                  color: Colors.black45,
                  margin: const EdgeInsets.only(right: 10),
                ),
                const Text('用户投稿',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            )
          ],
        ));
  }

  Widget _buildListGroupHeader(String header) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          '◆ $header ◆',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 169, 169, 169),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
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
        return const SliverToBoxAdapter(
          child: Center(child: Icon(UniconsLine.data_sharing)),
        );
      case ConnectionState.waiting:
        return const SliverToBoxAdapter(
            child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('加载中...')],
          ),
        ));
      case ConnectionState.active:
        final diaries = snapshot.data!;
        if (diaries.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [_buildListHeader(), const Text('空空如也～')],
          );
        }
        return SliverExpandableList(
            builder:
                SliverExpandableChildDelegate<Diary, _DiaryListViewSection>(
          controller: _controller,
          sectionList: _sections,
          sticky: true,
          headerBuilder: (context, sectionIndex, index) {
            return _buildListGroupHeader(_sections[sectionIndex].header);
          },
          itemBuilder: (context, sectionIndex, itemIndex, index) {
            return Container(
              height: 98,
              margin: const EdgeInsets.only(
                  bottom: 8.0, left: 10.0, right: 10.0), // 设置底部间距
              color: Colors.white, // 设置日记项的背景为白色
              child: DiaryListItem(
                  diary: _sections[sectionIndex].items[itemIndex]),
            );
          },
        ));
      case ConnectionState.done:
        return const Center(child: Text('Stream closed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xf6f7f9FF),
        drawer: const SettingDrawer(),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _pullRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildListHeader(),
                  ),
                  StreamBuilder(
                      stream: diaryService.diaryStream,
                      builder: _getBodyBySnapshotState)
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  color: stickySectionIndex == -1
                      ? Colors.transparent
                      : Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.menu_sharp),
                          onPressed: () =>
                              scaffoldKey.currentState?.openDrawer()),
                      stickySectionIndex > -1
                          ? Text(_sections[stickySectionIndex].header)
                          : Container(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          toAddDiaryPage();
                        },
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}

class DiaryListItem extends StatelessWidget {
  final Diary diary;

  const DiaryListItem({super.key, required this.diary});

  Future<bool> confirmDismiss(String text) async {
    return false;
  }

  Widget _buildLeft() {
    return Container(
      margin: const EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
          border: Border(
              right: BorderSide(color: Colors.grey.shade200, width: 0.7))),
      width: 70.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${diary.date.day}'.padLeft(2, '0'),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat('EEE', "zh_CN").format(diary.date),
            style: const TextStyle(
                fontSize: 12.0,
                height: 2,
                color: Color.fromARGB(255, 113, 113, 113)),
          ),
          Text(
              '${'${diary.date.hour}'.padLeft(2, '0')}:${'${diary.date.minute}'.padLeft(2, '0')}',
              style: const TextStyle(
                  fontSize: 10.0, color: Color.fromARGB(255, 168, 168, 168)))
        ],
      ),
    );
  }

  Widget _buildRight() {
    return Expanded(
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
    );
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
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DiaryDetailPage(diary: diary),
                    ),
                  );
                },
                child: Container(
                  height: 98,
                  padding: const EdgeInsets.only(
                      top: 12.0, right: 20.0, bottom: 12.0),
                  child: Row(
                    children: [
                      // 左边布局
                      _buildLeft(),
                      // 右边布局
                      _buildRight()
                    ],
                  ),
                ))));
  }
}

class _DiaryListViewSection implements ExpandableListSection<Diary> {
  late String header;
  late List<Diary> items;

  _DiaryListViewSection({
    required this.header,
    required this.items,
  });

  @override
  List<Diary> getItems() => items;

  @override
  bool isSectionExpanded() => true;

  @override
  void setSectionExpanded(bool expanded) {}
}
