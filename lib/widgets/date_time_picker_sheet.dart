import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_note/widgets/scroll_picker.dart';

typedef OnSelected = Function(DateTime date);
typedef OnClosed = Function(DateTime date);

class DateTimePickerSheet extends StatefulWidget {
  const DateTimePickerSheet(
      {super.key,
      this.selectedDate,
      this.onSelected,
      this.onClosed,
      this.startDate,
      this.endDate});

  final DateTime? selectedDate;
  final OnSelected? onSelected;
  final OnClosed? onClosed;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  _DateTimePickerSheetState createState() => _DateTimePickerSheetState();
}

class _DateTimePickerSheetState extends State<DateTimePickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // late FixedExtentScrollController yearScrollController;
  // late FixedExtentScrollController monthScrollController;
  // late FixedExtentScrollController dayScrollController;

  List<String> yearList = []; // 年数组
  List<String> monthList = []; // 月数组
  List<String> dayList = []; // 天数组

  int yearIndex = 0; // 年的索引
  int monthIndex = 0; // 月的索引
  int dayIndex = 0; //天的索引

  late DateTime startDate;
  late DateTime endDate;
  late DateTime selectedDate;

  final double itemExtent = 44;

  /// 初始化数据
  void initData() {
    // 初始化年份数
    for (int i = startDate.year; i <= endDate.year; i++) {
      yearList.add(i.toString());
    }
    int selectYear = selectedDate.year;
    int selectMonth = selectedDate.month;
    // 初始化月份数
    monthList = getMonthList(selectYear);
    // 初始化天数
    dayList = getDayList(selectYear, selectMonth);
    // 初始化时间索引
    final List uniqueYearList = Set.from(yearList).toList();
    final List uniqueMonthList = Set.from(monthList).toList();
    final List uniqueDayList = Set.from(dayList).toList();
    // 获取索引
    setState(() {
      yearIndex = uniqueYearList.indexOf("${selectedDate.year}");
      monthIndex = uniqueMonthList.indexOf("${selectedDate.month}");
      dayIndex = uniqueDayList.indexOf("${selectedDate.day}");
    });
    // 设置Picker初始值
    // yearScrollController = FixedExtentScrollController(initialItem: yearIndex);
    // monthScrollController =
    //     FixedExtentScrollController(initialItem: monthIndex);
    // dayScrollController = FixedExtentScrollController(initialItem: dayIndex);
  }

  List<String> getMonthList(int selectYear) {
    List<String> monthList = [];
    if (selectYear == startDate.year) {
      for (int i = startDate.month; i <= 12; i++) {
        monthList.add(i.toString());
      }
    } else if (selectYear == endDate.year) {
      for (int i = 1; i <= endDate.month; i++) {
        monthList.add(i.toString());
      }
    } else {
      for (int i = 1; i <= 12; i++) {
        monthList.add(i.toString());
      }
    }
    return monthList;
  }

  List<String> getDayList(int selectYear, int selectMonth) {
    List<String> dayList = [];
    int days = getDayCount(selectYear, selectMonth);
    if (selectYear == startDate.year && selectMonth == startDate.month) {
      for (int i = startDate.day; i <= days; i++) {
        dayList.add(i.toString());
      }
    } else if (selectYear == endDate.year && selectMonth == endDate.month) {
      for (int i = 1; i <= endDate.day; i++) {
        dayList.add(i.toString());
      }
    } else {
      for (int i = 1; i <= days; i++) {
        dayList.add(i.toString());
      }
    }
    return dayList;
  }

  int getDayCount(int year, int month) {
    int dayCount = DateTime(year, month + 1, 0).day;
    return dayCount;
  }

  /// 选中年月后更新天
  void updateDayList() {
    int year = int.parse(yearList[yearIndex]);
    int month = int.parse(monthList[monthIndex]);
    setState(() {
      dayIndex = 0;
      dayList = getDayList(year, month);
      // if (dayScrollController.positions.isNotEmpty) {
      //   dayScrollController.jumpTo(0);
      // }
    });
  }

  /// 选中年后更新月
  void updateMonthList() {
    int selectYear = int.parse(yearList[yearIndex]);
    setState(() {
      monthIndex = 0;
      monthList = getMonthList(selectYear);
      // if (monthScrollController.positions.isNotEmpty) {
      //   monthScrollController.jumpTo(0);
      // }
    });
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, animationDuration: Duration.zero);

    startDate = widget.startDate ?? DateTime(1970, 1, 1);
    endDate = widget.endDate ?? DateTime(2099, 1, 1);
    selectedDate = widget.selectedDate ?? DateTime.now();
    if (endDate.difference(startDate).inSeconds < 0) {
      endDate = startDate;
    }
    if (selectedDate.difference(startDate).inSeconds < 0) {
      selectedDate = startDate;
    }
    if (selectedDate.difference(endDate).inSeconds > 0) {
      selectedDate = endDate;
    }
    initData();
  }

  // @override
  // void dispose() {
  //   yearScrollController.dispose();
  //   monthScrollController.dispose();
  //   dayScrollController.dispose();
  //   super.dispose();
  // }

  Widget _buildCurrentTime() {
    return SizedBox(
        height: 50,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                        DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now())),
                  ),
                ),
              ],
            ),
            Positioned(
                right: 10,
                top: 11,
                child: SizedBox(
                    width: 80,
                    height: 28,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("当前时间"),
                    ))),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '日期'),
                Tab(text: '时间'),
              ],
            ),
            Expanded(
                child: Container(
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Date Tab
                  Column(
                    children: [
                      _buildCurrentTime(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            width: double.maxFinite,
                            height: 200,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  height: itemExtent - 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xEDEDEDED),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  top: 0,
                                  bottom: 0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                          child: ScrollPicker(
                                        list: yearList,
                                        type: '年',
                                        index: yearIndex,
                                      )),

                                      Expanded(
                                          child: ScrollPicker(
                                        list: monthList,
                                        type: '月',
                                        index: monthIndex,
                                      )),
                                      // widget.hideDay
                                      //     ? const SizedBox()
                                      //     :
                                      Expanded(
                                          child: ScrollPicker(
                                        list: dayList,
                                        type: '日',
                                        index: dayIndex,
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).padding.bottom),
                        ],
                      )
                    ],
                  ),
                  // Time Tab
                  Column(
                    children: [
                      _buildCurrentTime(),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: <Widget>[
                      //     SizedBox(
                      //       width: double.maxFinite,
                      //       height: 200,
                      //       child: Stack(
                      //         alignment: AlignmentDirectional.center,
                      //         children: [
                      //           Container(
                      //             width: MediaQuery.of(context).size.width - 32,
                      //             height: itemExtent - 8,
                      //             decoration: BoxDecoration(
                      //               color: const Color(0xEDEDEDED),
                      //               borderRadius: BorderRadius.circular(5),
                      //             ),
                      //           ),
                      //           Positioned(
                      //             left: 20,
                      //             right: 20,
                      //             top: 0,
                      //             bottom: 0,
                      //             child: Row(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: <Widget>[
                      //                 Expanded(child: yearPickerView()),
                      //                 Expanded(child: monthPickerView()),
                      //                 // widget.hideDay
                      //                 //     ? const SizedBox()
                      //                 //     :
                      //                 Expanded(child: dayPickerView()),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(
                      //         height: MediaQuery.of(context).padding.bottom),
                      //   ],
                      // )
                    ],
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
