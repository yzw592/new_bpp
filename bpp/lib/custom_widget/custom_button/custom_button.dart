import 'dart:async';

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {

  final StreamController stream;
  const CustomButton(this.stream, {super.key});

  @override
  State<CustomButton> createState() => _CusterButtonState();
}

class _CusterButtonState extends State<CustomButton> {
  List<Color> buttonColor = [Colors.white, Colors.grey[200]!]; //表示选择的颜色和没选择按钮的颜色
  List<Color> textColor = [Colors.red, Colors.black];

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.only(top: 15),child: getButtonBackGround(),);
  }

  Widget getButtonBackGround() {
    return Container(
        width: 80,
        height: 35,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        child: getButtonItem());
  }

  Widget getButtonItem() {
    return Row(children: [
      getButton("总量", buttonColor[0], textColor[0]),
      getButton("增量", buttonColor[1], textColor[1])
    ]);
  }

  Widget getButton(String buttonName, Color buttonColor, Color textColor) {
    return PhysicalModel(
      color: Colors.grey[200]!,
      elevation: buttonColor == Colors.white ? 1 : 0,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 35,
        height: 30,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(12)),
        child: TextButton(
          onPressed: buttonColor == Colors.white ? null : _selectButton,
          style: ButtonStyle(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            //设置按钮的大小
            minimumSize: MaterialStateProperty.all(const Size(5, 5)),
          ),
          child: Text(
            buttonName,
            style: TextStyle(color: textColor, fontSize: 13),
          ),
        ),
      ),
    );
  }

  void _selectButton() {
    //按钮颜色转变
    Color colorTemp = buttonColor[0];
    buttonColor[0] = buttonColor[1];
    buttonColor[1] = colorTemp;

    //文字颜色转变
    colorTemp = textColor[0];
    textColor[0] = textColor[1];
    textColor[1] = colorTemp;

    widget.stream.sink.add(buttonColor[0]);
    setState(() {});
  }
}
