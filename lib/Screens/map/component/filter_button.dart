// lib/screens/map/components/filter_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.tune, color: Color(0xFF0BC473)),
        onPressed: () {
          showFilterDialog(context);
        },
      ),
    );
  }

  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '필터',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('보건소'),
              value: true,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: Text('구청'),
              value: true,
              onChanged: (bool? value) {},
            ),
            // 추가 필터 옵션들...
          ],
        ),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('적용'),
            onPressed: () {
              // 필터 적용 로직
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
