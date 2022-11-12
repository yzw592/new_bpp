import 'package:flutter/material.dart';


class CustomBorder extends StatelessWidget {
  const CustomBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      elevation: 0.5,
      child: Container(
        color: Colors.grey[200],
        height: 20,
      ),
    );
  }
}
