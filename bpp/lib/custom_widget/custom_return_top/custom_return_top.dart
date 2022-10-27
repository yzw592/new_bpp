import 'package:flutter/material.dart';

class CustomReturnTop extends StatelessWidget {

  final ScrollController controller;
  const CustomReturnTop({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //得到返回顶部图标
    return Align(
      alignment: const Alignment(0.9, 0.9),
      child: Opacity(
        opacity: 0.7,
        child: FloatingActionButton(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/returntop.gif')),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
            onPressed: () {
              controller.animateTo(-30,
                  duration: const Duration(seconds: 1), curve: Curves.linear);
            }),
      ),
    );
  }
}
