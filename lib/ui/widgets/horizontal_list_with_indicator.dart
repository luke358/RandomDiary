import 'package:flutter/material.dart';

class HorizontalListWithIndicator extends StatefulWidget {
  final int itemCount;
  final List<String> itemTexts;
  final Function(int) onItemSelected;

  const HorizontalListWithIndicator({
    super.key,
    required this.itemCount,
    required this.itemTexts,
    required this.onItemSelected,
  });

  @override
  _HorizontalListWithIndicatorState createState() =>
      _HorizontalListWithIndicatorState();
}

class _HorizontalListWithIndicatorState
    extends State<HorizontalListWithIndicator> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.itemCount,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onItemSelected(_selectedIndex); // 调用回调函数
                },
                child: Container(
                  width: 40,
                  alignment: Alignment.center,
                  // padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.itemTexts[index],
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? Colors.blueAccent
                          : Colors.black,
                      fontWeight: _selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: 20,
          height: 2,
          color: Colors.blue, // 横杠颜色
          margin: EdgeInsets.only(left: _selectedIndex * 40 + 10), // 计算横杠位置
        ),
      ],
    );
  }
}
