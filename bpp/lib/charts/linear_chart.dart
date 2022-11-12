import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';

import '../custom_widget/custom_button/custom_button.dart';
import '../model/charts_model/linear_model.dart';
import '../model/user_model/user_week_data.dart';


class LinearChart extends StatefulWidget {
  final UserWeekData userWeekData;
  final String type;
  const LinearChart(this.userWeekData, this.type, {super.key});
  @override
  State<LinearChart> createState() => _LinearChartState();
}

class _LinearChartState extends State<LinearChart> with AutomaticKeepAliveClientMixin{
  final listenButton = StreamController();
  Color color = const Color(0xffffffff);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenButton.stream.listen((event) {
      setState(() {
          color = event;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listenButton.close();
  }

  @override
  Widget build(BuildContext context) {
    return _simpleLine();
  }

  Widget _simpleLine() {
    int count = 0;
    List<LinearModel> userData = [];
    switch (widget.type) {
      case 'fan':
        {
          if(color == const Color(0xffffffff)){
            userData = widget.userWeekData.fan
                .getRange(1, 8)
                .map((e) => LinearModel(count++, e))
                .toList();
          }else{
            for(int i = 1; i < 8; i++){
              userData.add(LinearModel(count++, widget.userWeekData.fan[i] - widget.userWeekData.fan[i - 1]));
            }
          }

          break;
        }
      case 'care':
        {
          if(color == const Color(0xffffffff)){
            userData = widget.userWeekData.care
                .getRange(1, 8)
                .map((e) => LinearModel(count++, e))
                .toList();
          }else{
            for(int i = 1; i < 8; i++){
              userData.add(LinearModel(count++, widget.userWeekData.care[i] - widget.userWeekData.care[i - 1]));
            }
          }
          break;
        }
      case 'good':
        {
          if(color == const Color(0xffffffff)){
            userData = widget.userWeekData.good
                .getRange(1, 8)
                .map((e) => LinearModel(count++, e))
                .toList();
          }else{
            for(int i = 1; i < 8; i++){
              userData.add(LinearModel(count++, widget.userWeekData.good[i] - widget.userWeekData.good[i - 1]));
            }
          }
          break;
        }
      case 'see':
        {
          if(color == const Color(0xffffffff)){
            userData = widget.userWeekData.see
                .getRange(1, 8)
                .map((e) => LinearModel(count++, e))
                .toList();
          }else{
            for(int i = 1; i < 8; i++){
              userData.add(LinearModel(count++, widget.userWeekData.see[i] - widget.userWeekData.see[i - 1]));
            }
          }
          break;
        }
    }
    var seriesList = [
      charts.Series<LinearModel, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearModel sales, _) => sales.day,
        measureFn: (LinearModel sales, _) => sales.sales,
        data: userData,
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(padding: const EdgeInsets.only(right: 20),child: CustomButton(listenButton)),  //增量和总量按钮
        const SizedBox(
          width: 100,
        ),
        Container(
          padding: const EdgeInsets.all(8),
            height: 250, child: charts.LineChart(seriesList, animate: true)), //绘制图表
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
