import 'package:bppnew/charts/pie_charts.dart';
import 'package:bppnew/custom_widget/custom_border/custom_border.dart';
import 'package:bppnew/custom_widget/custom_get_sex/custom_get_sex.dart';
import 'package:bppnew/custom_widget/custom_tabbar/custom_video_tabbar.dart';
import 'package:bppnew/get_data/get_user_data/get_user_data.dart';
import 'package:bppnew/model/user_model/user_model.dart';
import 'package:flutter/material.dart';
import '../custom_widget/custom_appbar/custom_appbar.dart';
import '../custom_widget/custom_loading/custom_loading.dart';
import '../get_data/get_video_data/get_video_data.dart';
import '../model/video_model/video_model.dart';

class VideoDetail extends StatefulWidget {
  final VideoBriefModel videoBriefModel;

  const VideoDetail(this.videoBriefModel, {super.key});

  @override
  State<VideoDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<VideoDetail> {
  VideoDetailModel? videoDetailModel;
  UserDetailModel? userDetailModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUserData.getSingleUserData(widget.videoBriefModel.uid).then((value) {
      setState(() {
        userDetailModel = value;
      });
    });
    GetVideoData.getVideoDetailData(widget.videoBriefModel).then((value) {
      setState(() {
        videoDetailModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "视频详细页面",
          backgroundColor: Colors.pink[200],
        ),
        body: getBody());
  }

  Widget getBody() {
    if (videoDetailModel == null || userDetailModel == null) {
      return const CustomLoading();
    } else {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getVideoHead(), //得到头像
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getName(), //得到视频名称
                    getRankAndCreateTime(), //得到排名和创建时间
                  ],
                ),
              ),
            ],
          ),
          const CustomBorder(), //分割线
          getUserDetail(), //得到用户详细信息
          const SizedBox(
            height: 8,
          ),
          const CustomBorder(), //分割线
          getVideoDetail(), //得到视频核心数据和绘制饼图
        ],
      );
    }
  }

  Widget getVideoHead() {
    return Container(
      width: 120,
      height: 80,
      margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('https://${videoDetailModel!.videoPicUrl}'),
              fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget getName() {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        widget.videoBriefModel.videoName,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget getRankAndCreateTime() {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            "${widget.videoBriefModel.sort}视频排名:第${widget.videoBriefModel.rank}名",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Text("发布时间:${videoDetailModel!.cTime}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ),
      ],
    );
  }

  Widget getUserDetail() {
    return Row(
      children: <Widget>[
        getUserHead(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                getUserData(userDetailModel!.name,
                    left: 5, right: 5, top: 6), //得到用户名
                CustomGetSex(
                  //得到用户性别
                  sex: userDetailModel!.sex,
                  top: 10,
                  bottom: 5,
                  size: 16,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 5, left: 6),
                      child: Row(
                        children: <Widget>[
                          getUserData("uid: ${userDetailModel!.uid}", left: 1),
                        ],
                      ),
                    ),
                    getUserData("播放量: ${userDetailModel!.see}",
                        left: 5, top: 5), //得到播放量
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getUserData("粉丝量: ${userDetailModel!.fan}",
                        left: 15, top: 5),
                    getUserData("关注: ${userDetailModel!.care}",
                        left: 15, top: 5)
                  ],
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget getUserHead() {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 5),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(userDetailModel!.picUrl)),
          borderRadius: const BorderRadius.all(Radius.circular(40))),
    );
  }

  Widget getUserData(String name,
      {double left = 0, double right = 0, double top = 0, double bottom = 0}) {
    return Container(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        name,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget getVideoDetail() {
    return Expanded(
        child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        getTitle(), //视频核心标题
        Container(
          padding: const EdgeInsets.only(left: 80, right: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getVideoData(videoDetailModel!.videoLike, "点赞量",
                  videoDetailModel!.videoShare, "分享量"), //得到点赞数和分享量
              getVideoData(videoDetailModel!.favorite, "收藏量",
                  videoDetailModel!.coin, "投币量"), //得到收藏数和硬币量
              getVideoData(videoDetailModel!.detailVideoSee, "播放量",
                  videoDetailModel!.comment, "评论量"), //得到视频播放量和评论量
            ],
          ),
        ),
        const SizedBox(height: 10,),
        const CustomBorder(), //分割线
        PieCharts(videoDetailModel: videoDetailModel!),//绘制饼图
        CustomVideoTabBar(videoDetailModel: videoDetailModel!, userDetailModel: userDetailModel!)
      ],
    ));
  }

  Widget getTitle() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5),
        child: const Text(
          "视频核心数据",
          style: TextStyle(fontSize: 18),
        ));
  }

  Widget getVideoData(String topData, String topDataName, String bottomData,
      String bottomDataName) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(topData, style: const TextStyle(fontSize: 16)),
        ),
        Container(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            topDataName,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(bottomData, style: const TextStyle(fontSize: 16)),
        ),
        Container(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            bottomDataName,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        )
      ],
    );
  }
}
