import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomGetSex extends StatefulWidget {
  final String sex;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double size;
  const CustomGetSex(
      {Key? key,
      required this.sex,
      this.top = 0,
      this.left = 0,
      this.right = 0,
      this.bottom = 0,
      this.size = 15})
      : super(key: key);

  @override
  State<CustomGetSex> createState() => _CustomGetSexState();
}

class _CustomGetSexState extends State<CustomGetSex> {
  @override
  Widget build(BuildContext context) {
    return getSex();
  }

  Widget getSex() {
    if (widget.sex != '未知') {
      if (widget.sex == '男') {
        return Container(
          padding: EdgeInsets.only(
              left: widget.left,
              right: widget.right,
              bottom: widget.bottom,
              top: widget.top),
          child: Icon(
            FontAwesomeIcons.mars,
            size: widget.size,
            color: Colors.blue,
          ),
        );
      } else {
        return Container(
          padding:  EdgeInsets.only(
              left: widget.left,
              right: widget.right,
              bottom: widget.bottom,
              top: widget.top),
          child: Icon(
            FontAwesomeIcons.venus,
            size: widget.size,
            color: Colors.red,
          ),
        );
      }
    } else {
      return Container();
    }
  }
}
