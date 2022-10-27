import 'package:bppnew/custom_widget/custom_drawer/config_drawer.dart';
import 'package:bppnew/video/video_list_item.dart';
import 'package:flutter/material.dart';

import '../../../user/user_list_item.dart';

class RankDrawer extends StatefulWidget {
  final String? rankName;
  final List rankList;
  final IconData rankHeadIcon;
  final Color headIconColor;
  final IconData rankItemIcon;
  final Color rankItemIconColor;
  final double iconSize;

  const RankDrawer(
      {super.key,
      required this.rankName,
      required this.rankList,
      this.rankHeadIcon = Icons.supervised_user_circle_sharp,
      this.headIconColor = const Color(0xFFF48FB1),
      this.rankItemIcon = Icons.supervised_user_circle_sharp,
      this.rankItemIconColor = const Color(0xFFF48FB1),
      this.iconSize = 50});

  @override
  State<RankDrawer> createState() => _RankDrawerState();
}

class _RankDrawerState extends State<RankDrawer> {
  List indexFlag = [false, false];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (index, flag) {
          setState(() {
            indexFlag[index] = !indexFlag[index];
          });
        },
        children: <ExpansionPanel>[
          getExpansionPanel() //得到抽屉里面的详细item
        ],
      ),
    );
  }

  ExpansionPanel getExpansionPanel() {
    return ExpansionPanel(
        headerBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: <Widget>[
                Icon(
                  widget.rankHeadIcon,
                  size: widget.iconSize,
                  color: widget.headIconColor,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      widget.rankName.toString(),
                      style: const TextStyle(color: Colors.black),
                    ))
              ],
            ),
          );
        },
        body: ListView.builder(
          itemCount: widget.rankList.length,
          shrinkWrap: true,
          itemExtent: 60,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
                child: Row(
                  children: <Widget>[
                    Icon(
                      widget.rankItemIcon,
                      size: widget.iconSize,
                      color: widget.rankItemIconColor,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      width: 184,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 0.1, color: Colors.black))),
                      child: Text(
                        widget.rankList[index] + "排行榜",
                        style: const TextStyle(color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  _jumpToNewPage(index);
                });
          },
        ),
        isExpanded: indexFlag[0],
        canTapOnHeader: true);
  }

  _jumpToNewPage(int index) {
    if (USER_SORT.contains(widget.rankList[index])) {
      //跳转至新页面（用户）
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  UserListItem(widget.rankList[index])));
    } else {   //（视频）
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  VideoListItem(widget.rankList[index])));
    }
  }
}
