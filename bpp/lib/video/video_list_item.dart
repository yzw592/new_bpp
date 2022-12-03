import 'package:bppnew/video/video_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom_widget/custom_appbar/custom_appbar.dart';
import '../custom_widget/custom_drawer/custom_drawer.dart';
import '../custom_widget/custom_loading/custom_loading.dart';
import '../custom_widget/custom_rank_label/custom_rank_lable.dart';
import '../custom_widget/custom_return_top/custom_return_top.dart';
import '../custom_widget/custom_search/custom_search.dart';
import '../get_data/get_video_data/get_video_data.dart';
import '../model/video_model/video_model.dart';

class VideoListItem extends StatefulWidget {
  final String title;
  const VideoListItem(this.title, {super.key});

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  List<VideoBriefModel> videoBriefModel = [];
  int flag = 0; //记录ListViewBuilder的下标，方便对象取值
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetVideoData.getVideoBriefData(widget.title).then((value) {
      setState(() {
        videoBriefModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        title: '${widget.title}视频排行榜',
        backgroundColor: Colors.pink[200],
        icon: const [
          CustomSearch(
            icon: Icon(Icons.search),
            type: 'video',
          )
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (videoBriefModel.isEmpty) {
      return const CustomLoading();
    } else {
      return Stack(
        children: [getItem(), getReturnTop()],
      );
    }
  }

  Widget getItem() {
    return ListView.builder(
        itemCount: videoBriefModel.length,
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          flag = index;
          return getItemContainer(index);
        });
  }

  Widget getItemContainer(int index) {
    return TextButton(
      onPressed: () {
        jumpToVideoDetailPage(index);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5, bottom: 4, top: 5),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey))),
        child: getItemDetail(),
      ),
    );
  }

  void jumpToVideoDetailPage(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                VideoDetail(videoBriefModel[index])));
  }

  Widget getItemDetail() {
    return Row(
      children: [
        Stack(
          children: [
            getHead(), //得到视频封面
            getRankLabel(), //得到排行榜小图标
          ],
        ),
        getOtherData(), //得到其他视频信息
      ],
    );
  }

  Widget getHead() {
    return Hero(
      tag: videoBriefModel[flag].videoPicUrl,
      child: Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://${videoBriefModel[flag].videoPicUrl}'),
                  fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ))),
    );
  }

  Widget getRankLabel() {
    return CustomRankLabel(rank: videoBriefModel[flag].rank);
  }

  Widget getOtherData() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVideoName(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getPlayIcon(), //得到播放图标
            getSee(), //得到视频播放人数
            getCommentIcon(), // 得到评论图标
            getComment(), //得到评论人数
            getUserIcon(), //得到用户图标
            getUserName() //得到用户名称
          ],
        )
      ],
    ));
  }

  Widget getVideoName() {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
      ),
      child: Text(
        videoBriefModel[flag].videoName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }

  Widget getPlayIcon() {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 8),
      child: const Icon(
        FontAwesomeIcons.circlePlay,
        size: 16,
        color: Colors.black,
      ),
    );
  }

  Widget getSee() {
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 8),
      child: Text(
        videoBriefModel[flag].videoSee.toString(),
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget getCommentIcon() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 8),
      child: const Icon(
        FontAwesomeIcons.comment,
        size: 16,
        color: Colors.black,
      ),
    );
  }

  Widget getComment() {
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 8),
      child: Text(
        videoBriefModel[flag].comment,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget getUserIcon() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 8),
      child: const Icon(
        FontAwesomeIcons.circleUser,
        color: Colors.black,
        size: 16,
      ),
    );
  }

  Widget getUserName() {
    String name = videoBriefModel[flag].userName;
    if (videoBriefModel[flag].userName.length > 5) {
      name = "${videoBriefModel[flag].userName.substring(0,5)}···";
    }
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 8),
      child: Text(
        name,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget getReturnTop() {
    return CustomReturnTop(
      controller: controller,
    );
  }
}
