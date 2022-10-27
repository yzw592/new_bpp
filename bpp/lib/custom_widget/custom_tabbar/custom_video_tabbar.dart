import 'package:bppnew/model/user_model/user_model.dart';
import 'package:bppnew/model/video_model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomVideoTabBar extends StatefulWidget {
  final VideoDetailModel videoDetailModel;
  final UserDetailModel userDetailModel;
  const CustomVideoTabBar(
      {Key? key, required this.videoDetailModel, required this.userDetailModel})
      : super(key: key);
  @override
  State<CustomVideoTabBar> createState() => _CustomVideoTabBarState();
}

class _CustomVideoTabBarState extends State<CustomVideoTabBar>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int page = 0;
  double pageHeight = 100;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: [
            getTab("相关推荐"),
            getTab("用户其他视频"),
            getTab("视频评论"),
          ],
          onTap: (pageIndex) {
            getHeight(pageIndex);
          },
        ),
        SizedBox(
          height: pageHeight,
          child: TabBarView(controller: tabController, children: [
            const Text("页面正在完善"),
            getOtherVideoPage(), //得到用户其他视频页面
            getCommentPage(),
          ]),
        ),
      ],
    );
  }

  void getHeight(int pageIndex) {
    if (pageIndex != page) {
      switch (pageIndex) {
        case 0:
          {
            pageHeight = 100.0;
            page = pageIndex;
            break;
          }
        case 1:
          {
            pageHeight = 91.0 * widget.userDetailModel.totalVideo.length;
            page = pageIndex;
            break;
          }
        case 2:
          {
            pageHeight = 97.0 * widget.videoDetailModel.detailComment.length;
            page = pageIndex;
            break;
          }
      }
      setState(() {});
    }
  }

  Tab getTab(
    String title,
  ) {
    return Tab(
      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget getOtherVideoPage() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.userDetailModel.totalVideo.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.4, color: Colors.black))),
            child: Row(
              children: [
                getVideoPhoto(index), //得到视频封面
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getVideoName(index), //得到视频名字
                      getSeeAndComment(index), //得到视频播放量喝评论量
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget getVideoPhoto(int index) {
    return Container(
      height: 80,
      width: 120,
      margin: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https:${widget.userDetailModel.totalVideo[index]['pic'].toString().substring(5)}"),
              fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget getVideoName(int index) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Text(widget.userDetailModel.totalVideo[index]['视频名']),
    );
  }

  Widget getSeeAndComment(int index) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            FontAwesomeIcons.circlePlay,
            color: Colors.grey[600],
            size: 13,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, top: 2),
          child: Text(
            widget.userDetailModel.totalVideo[index]['see'].toString(),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          child: Icon(
            FontAwesomeIcons.comment,
            color: Colors.grey[600],
            size: 13,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, top: 2),
          child: Text(
            widget.userDetailModel.totalVideo[index]['评论数'].toString(),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget getCommentPage() {
    return ListView.builder(
        itemCount: widget.videoDetailModel.detailComment.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.4))),
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            child: getCommentItem(index),
          );
        });
  }

  Widget getCommentItem(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getCommentUser(index), //得到用户头像和名字
        const SizedBox(
          width: 8,
        ),
        getComment(index),//得到用户评论
        const SizedBox(
          width: 5,
        ),
        getLike(index), //得到点赞人数
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Widget getCommentUser(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://${widget.videoDetailModel.detailComment[index]['用户头像'].split("//")[1]}")),
              borderRadius: BorderRadius.circular(30)),
          height: 60,
          width: 60,
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 75,
          child: Text(
            widget.videoDetailModel.detailComment[index]['用户名'],
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget getComment(int index) {
    return Expanded(
          child: Text(
        widget.videoDetailModel.detailComment[index]['评论'],
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
            style: const TextStyle(fontSize: 15),
      ));
  }

  Widget getLike(int index){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.pink[200],),
        const SizedBox(height: 5,),
        Text(widget.videoDetailModel.detailComment[index]['点赞人数'].toString()),
      ],
    );
  }
}
