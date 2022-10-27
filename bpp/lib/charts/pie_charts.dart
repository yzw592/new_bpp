import 'package:bppnew/model/charts_model/pie_model.dart';
import 'package:bppnew/model/video_model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieCharts extends StatefulWidget {
  final VideoDetailModel videoDetailModel;
  const PieCharts({Key? key, required this.videoDetailModel}) : super(key: key);

  @override
  State<PieCharts> createState() => _PieChartState();
}

class _PieChartState extends State<PieCharts> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 177,
        child: getChart(),
      ),
    );
  }

  Widget getChart(){
    List<PieModel> dataList = [
      PieModel("收藏", int.parse(widget.videoDetailModel.favorite), charts.ColorUtil.fromDartColor(Colors.red)),
      PieModel("点赞", int.parse(widget.videoDetailModel.videoLike), charts.ColorUtil.fromDartColor(Colors.blue)),
      PieModel("硬币", int.parse(widget.videoDetailModel.coin), charts.ColorUtil.fromDartColor(Colors.green)),
    ];
    int sum = int.parse(widget.videoDetailModel.favorite) + int.parse(widget.videoDetailModel.videoLike) + int.parse(widget.videoDetailModel.coin);
    var seriesList = [
      charts.Series<PieModel, String>(
          id: "pie",
          domainFn: (PieModel sales, _) => sales.x,
          measureFn: (PieModel sales, _) => sales.y,
          colorFn: (PieModel sales, _) => sales.color,
          labelAccessorFn: (PieModel sales, _) =>
          '${sales.x}:${sales.y}' '\n占比:${(sales.y / sum * 100).toStringAsFixed(2)}%',
          data: dataList)
    ];

    return charts.PieChart(seriesList,
        animate: true,
        animationDuration: const Duration(seconds: 1),

    );
  }
}

