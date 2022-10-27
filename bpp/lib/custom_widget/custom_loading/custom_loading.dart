import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final Color backGroundColor;
  final double width;
  final double height;
  final String loadingText;

  const CustomLoading(
      {super.key, this.loadingText = "正在加载中······",
      this.width = 150,
      this.height = 150,
      this.backGroundColor = const Color(0xFFFFFFFF)});
  @override
  Widget build(BuildContext context) {
    return getDialog();
  }

  Widget getDialog() {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: backGroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: <Widget>[getLoadingImage(), getLoadingText()],
        ),
      ),
    );
  }

  Widget getLoadingImage() {
    return SizedBox(
      width: 130,
      height: 120,
      child: Image.asset(
        'assets/images/loading.gif',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getLoadingText() {
    return Text(
      loadingText,
      style: const TextStyle(fontSize: 15),
    );
  }
}
