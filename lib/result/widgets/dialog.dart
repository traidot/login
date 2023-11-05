import 'package:flutter/material.dart';

// Hàm để hiển thị dialog
Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, // Đặt giá trị true để cho phép người dùng bấm ngoài dialog để đóng dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thông báo'),
        content: Text('Đây là nội dung thông báo trong dialog.'),
        actions: <Widget>[
          TextButton(
            child: Text('Đóng'),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Đóng dialog khi người dùng bấm nút Đóng
            },
          ),
        ],
      );
    },
  );
}
