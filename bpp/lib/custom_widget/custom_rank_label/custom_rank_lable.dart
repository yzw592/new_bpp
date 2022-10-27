import 'package:flutter/material.dart';


class CustomRankLabel extends StatelessWidget {

  final String rank;
  const CustomRankLabel({Key? key, required this.rank}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getRank();
  }

  Widget getRank(){
    switch(rank){
      case '1' : return getRankLabel(Colors.amber);
      case '2' : return getRankLabel(Colors.green);
      case '3' : return getRankLabel(Colors.red);
      default: return getRankLabel(Colors.grey);
    }
  }

  Widget getRankLabel(Color color){
    return Container(
      alignment: AlignmentDirectional.center,
      width: int.parse(rank) > 99 ? 32 : 25,
      height: 25,
      decoration:  BoxDecoration(
          borderRadius: const BorderRadius.only(bottomRight : Radius.circular(20)),
          color: color),
      child: Text(
        rank.toString(),
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
