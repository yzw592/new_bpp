import 'package:bppnew/custom_widget/custom_border/custom_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../charts/linear_chart.dart';
import '../../model/user_model/user_week_data.dart';

class CustomTabBar extends StatefulWidget {
  final UserWeekData userWeekData;
  const CustomTabBar(this.userWeekData, {super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  List<Color> buttonColor = [
    Colors.red,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  List<Color> textColor = [
    Colors.white,
    Colors.black,
    Colors.black,
    Colors.black
  ];
  List<double> textSize = [14, 12, 12, 12];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(), //近7天数据变化
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [getTabBar()],
            ),
            const CustomBorder(),
            getTabBarView()
          ],
        ));
  }

  Widget getTitle() {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Icon(
              FontAwesomeIcons.chartLine,
              color: Colors.pink[200],
            )),
        Container(
          padding: const EdgeInsets.only(top: 8, left: 5),
          child: const Text(
            "近7日数据变化",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  void colorTemp(int index) {
    if (index != 0) {
      buttonColor = [Colors.white, Colors.white, Colors.white, Colors.white];
      textColor = [Colors.black, Colors.black, Colors.black, Colors.black];
      textSize = [12, 12, 12, 12];
      buttonColor[index - 1] = Colors.red;
      textColor[index - 1] = Colors.white;
      textSize[index - 1] = 14;
      setState(() {});
    } else {
      buttonColor = [Colors.red, Colors.white, Colors.white, Colors.white];
      textColor = [Colors.white, Colors.black, Colors.black, Colors.black];
      textSize = [15, 12, 12, 12];
    }
  }

  Widget getTabBar() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        child: TabBar(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            indicatorPadding: const EdgeInsets.all(0),
            labelPadding: const EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.transparent,
            isScrollable: false,
            onTap: (index) {
              colorTemp(index);
            },
            controller: controller,
            tabs: [
              const Tab(
                child: Text(
                  "数据纬度",
                  style: TextStyle(color: Colors.black,fontSize: 15),
                ),
              ),
              getTabBarItem("粉丝", buttonColor[0], textColor[0], textSize[0]),
              getTabBarItem("播放量", buttonColor[1], textColor[1], textSize[1]),
              getTabBarItem("点赞", buttonColor[2], textColor[2], textSize[2]),
              getTabBarItem("充电", buttonColor[3], textColor[3], textSize[3]),
            ]),
      ),
    );
  }

  Widget getTabBarItem(String type, Color buttonColor, Color textColor, double textSize) {
    return Tab(
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: 60,
        height: 24,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(15)),
        child: Text(
          type,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ),
    );
  }

  Widget getTabBarView() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: TabBarView(
        controller: controller,
        children: [
          getChart("fan"),
          getChart("fan"),
          getChart("see"),
          getChart("good"),
          getChart("care"),
        ],
      ),
    );
  }

  Widget getChart(String type) {
    return LinearChart(widget.userWeekData, type);
  }
}
