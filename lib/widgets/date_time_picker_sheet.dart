import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  List<String> hourType = ['上午', '下午'];
  List<String> hourList = List.generate(12, (index) => (index + 1).toString());
  List<String> minuteList =
      List.generate(60, (index) => (index).toString().padLeft(2, '0'));

  int yearIndex = 0; // 年的索引
  int monthIndex = 0; // 月的索引
  int dayIndex = 0; //天的索引

  int hourTypeIndex = 0;
  int hourIndex = 0;
  int minuteIndex = 0;

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
    setState(() {
      yearIndex = yearList.indexOf("${selectedDate.year}");
      monthIndex = monthList.indexOf("${selectedDate.month}");
      dayIndex = dayList.indexOf("${selectedDate.day}");
      hourTypeIndex = selectedDate.hour > 12 ? 1 : 0;
      hourIndex = hourList.indexOf("${selectedDate.hour % 12}");
      minuteIndex = minuteList.indexOf("${(selectedDate.minute)}");
    });
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

  Widget _buildCurrentTime() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
        child: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    DateFormat(
                      'yyyy/MM/dd HH:mm',
                    ).format(selectedDate),
                  ),
                )),
            Positioned(
                right: 20,
                top: 0,
                child: SizedBox(
                    width: 60,
                    height: 20,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          // selectedDate = DateTime.now();
                          // dayIndex = selectedDate.day;
                          // monthIndex = selectedDate.month;
                          // yearIndex = selectedDate.year;
                          // hourIndex = selectedDate.hour;
                          // minuteIndex = selectedDate.minute;
                        });
                      },
                      child: const Text("当前时间", style: TextStyle(fontSize: 12.0),),
                    ))),
          ],
        ));
  }

  void onSelected(int index, String type) {
    switch (type) {
      case 'year':
        yearIndex = index;
        break;
      case 'month':
        monthIndex = index;
        break;
      case 'day':
        dayIndex = index;
        break;
      case 'hourType': // 0 上午 1 下午
        hourTypeIndex = index;
        break;
      case 'hour':
        hourIndex = index;
        break;
      case 'minute':
        minuteIndex = index;
        break;
      default:
        print('error');
    }
    setState(() {
      selectedDate = DateTime(
          int.parse(yearList[yearIndex]),
          int.parse(monthList[monthIndex]),
          int.parse(dayList[dayIndex]),
          int.parse(hourList[hourIndex]) + (hourTypeIndex == 1 ? 12 : 0),
          int.parse(minuteList[minuteIndex]));
      widget.onSelected!(selectedDate);
    });
  }

  Widget _buildTimeTab() {
    return Column(
      children: [
        _buildCurrentTime(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.maxFinite,
              height: 150,
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
                          list: hourType,
                          type: '',
                          index: hourTypeIndex,
                          onSelected: (index) => onSelected(index, 'hourType'),
                        )),
                        Expanded(
                            child: ScrollPicker(
                          list: hourList,
                          type: '',
                          index: hourIndex,
                          onSelected: (index) => onSelected(index, 'hour'),
                        )),
                        Expanded(
                            child: ScrollPicker(
                          list: minuteList,
                          type: '',
                          index: minuteIndex,
                          onSelected: (index) => onSelected(index, 'minute'),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        )
      ],
    );
  }

  Widget _buildDateTab() {
    return Column(
      children: [
        _buildCurrentTime(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.maxFinite,
              height: 150,
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
                            flex: 1,
                            child: ScrollPicker(
                              list: yearList,
                              type: '年',
                              index: yearIndex,
                              onSelected: (index) => onSelected(index, 'year'),
                            )),
                        Expanded(
                            flex: 1,
                            child: ScrollPicker(
                              list: monthList,
                              type: '月',
                              index: monthIndex,
                              onSelected: (index) => onSelected(index, 'month'),
                            )),
                        Expanded(
                            flex: 1,
                            child: ScrollPicker(
                              list: dayList,
                              type: '日',
                              index: dayIndex,
                              onSelected: (index) => onSelected(index, 'day'),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        )
      ],
    );
  }

  Widget _buildTabView() {
    return Expanded(
        flex: 1,
        child: Container(
          color: Colors.white,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Date Tab
              _buildDateTab(),
              // Time Tab
              _buildTimeTab()
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 340,
        color: Colors.white,
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
            _buildTabView(),
          ],
        ));
  }
}
