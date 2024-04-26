import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_note/ui/widgets/horizontal_list_with_indicator.dart';

Widget textBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text(
              '对齐',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 50),
            Icon(Icons.format_align_left_outlined),
            SizedBox(width: 50),
            Icon(Icons.format_align_center_outlined),
            SizedBox(width: 50),
            Icon(Icons.format_align_right_outlined)
          ],
        ),
        const Row(
          children: [
            Text(
              '对齐',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 50),
            Text('常体'),
            SizedBox(width: 45),
            Text('粗体'),
          ],
        ),
        Row(
          children: [
            const Text('大小'),
            const SizedBox(width: 50),
            Expanded(
                child: HorizontalListWithIndicator(
                    itemCount: 4,
                    itemTexts: ['1', '2', '3', '4'],
                    onItemSelected: (index) {
                      print('Selected item index: $index');
                    }))
          ],
        ),
        Column(
          children: [
            Container(margin: EdgeInsets.only(bottom: 20),child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('颜色'),
                const SizedBox(width: 50),
                Container(
                  color: Colors.black,
                  height: 25,
                  width: 40,
                )
              ],
            ),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TODO: ListView
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2.0, color: Colors.black), // 设置边框
                  ),
                  height: 45,
                  width: 45,
                  child: Container(
                    color: Colors.black,
                  ),
                )
              ],
            )
          ],
        )
      ],
    ),
  );
}
