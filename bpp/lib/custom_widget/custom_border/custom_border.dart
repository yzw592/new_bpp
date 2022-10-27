import 'package:flutter/material.dart';


class CustomBorder extends StatelessWidget {
  const CustomBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 20, color:  Color(0xFFEEEEEE)))),
    );
  }
}
