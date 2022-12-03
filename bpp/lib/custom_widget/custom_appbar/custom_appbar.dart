import 'package:flutter/material.dart';

/// 自定义AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color ? backgroundColor;
  final String title;
  @override
  final Size preferredSize;
  final List<Widget>? icon;
  const CustomAppBar({Key ? key, this.backgroundColor, required this.title, this.preferredSize = const Size(double.infinity, 50), this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        elevation: 5,
        actions: icon,
        backgroundColor: backgroundColor,
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
