import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollPicker extends StatefulWidget {
  const ScrollPicker(
      {super.key,
      required this.list,
      this.index,
      this.type,
      this.startDate,
      this.endDate});

  final int? index;
  final String? type;
  final List<String> list;
  final DateTime? startDate;
  final DateTime? endDate;
  @override
  State<ScrollPicker> createState() => _ScrollPickerState();
}

class _ScrollPickerState extends State<ScrollPicker> {
  late FixedExtentScrollController scrollController;
  late int index;

  late String type = '年';

  final double itemExtent = 44;
  List<String> list = [];

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    index = widget.index ?? 0;
    type = widget.type ?? '年';

    startDate = widget.startDate ?? DateTime(1970, 1, 1);
    endDate = widget.endDate ?? DateTime(2099, 1, 1);

    if (endDate.difference(startDate).inSeconds < 0) {
      endDate = startDate;
    }

    scrollController = FixedExtentScrollController(initialItem: index);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildPickerBorder(
      child: CupertinoPicker(
        scrollController: scrollController,
        looping: false,
        selectionOverlay: const Center(),
        onSelectedItemChanged: (index) {
          setState(() {
            index = index;
          });
          // updateMonthList();
          // updateDayList();
        },
        itemExtent: itemExtent,
        children: buildWidget(),
      ),
    );
  }

  List<Widget> buildWidget() {
    List<Widget> widgets = [];
    for (var i = 0; i < list.length; i++) {
      widgets.add(
        Center(
          child: Text(
            list[i],
            style: getTextStyle(i == index),
            maxLines: 1,
          ),
        ),
      );
    }
    return widgets;
  }

  Widget buildPickerBorder({required Widget child}) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        child,
        Positioned(
          right: 0,
          child: Text(type),
        )
      ],
    );
  }

  TextStyle getTextStyle(bool bold) {
    return TextStyle(
      color: Colors.black,
      fontSize: 20,
      height: 1,
      fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
    );
  }
}
