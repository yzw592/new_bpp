import 'package:flutter/material.dart';

extension FixAutoLines on String {
  //防止提前换行
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}

class CustomSign extends StatefulWidget {
  final String ? sign;
  final double ? maxWidth;
  final int ? maxLines;
  const CustomSign({super.key, @required this.sign, this.maxWidth = 10, this.maxLines = 1});
  @override
  State<CustomSign> createState() => _CustomSignState();
}

class _CustomSignState extends State<CustomSign> {
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return hideText();
  }

  Widget hideText() {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        text: TextSpan(text: widget.sign?.fixAutoLines()));
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - double.parse(widget.maxWidth.toString()));
    return isHideText(textPainter.didExceedMaxLines);
  }

  Widget isHideText(bool isHide) {
    if (isHide) {
      return getHideText();
    } else {
      return getText();
    }
  }

  Widget getHideText() {
    if(flag){
      return Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                  text: widget.sign?.fixAutoLines(),
                  style: TextStyle(color: Colors.grey[600])),
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          TextButton(
            onPressed: onPressFunction,
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(0),
                ),
                minimumSize: MaterialStateProperty.all(const Size(5, 5))),
            child: const Text(
              "展开",
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      );
    }else{
        return Row(
          children: [
            Expanded(
              child: Text(widget.sign.toString().fixAutoLines(),style: TextStyle(color: Colors.grey[600]),)
            ),
            TextButton(
              onPressed: onPressFunction,
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(0),
                  ),
                  minimumSize: MaterialStateProperty.all(const Size(5, 5))),
              child: const Text(
                "收起",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        );
    }
  }

  Widget getText() {
    return Text(widget.sign.toString().fixAutoLines(), style: TextStyle(color: Colors.grey[600]),);
  }

  void onPressFunction(){
    setState(() {
      flag = !flag;
    });
  }
}
