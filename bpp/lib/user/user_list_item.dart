import 'package:bppnew/custom_widget/custom_search/custom_search.dart';
import 'package:bppnew/user/user_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_widget/custom_appbar/custom_appbar.dart';
import '../custom_widget/custom_drawer/custom_drawer.dart';
import '../custom_widget/custom_loading/custom_loading.dart';
import '../custom_widget/custom_return_top/custom_return_top.dart';
import '../get_data/get_user_data/get_user_data.dart';
import '../model/user_model/user_model.dart';



class UserListItem extends StatefulWidget {
  final String title;

  const UserListItem(this.title, {super.key});
  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  List<UserModel> data = []; //存放用户数据
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUserData.getUserData(widget.title).then((res) {
      data = res;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        title: '${widget.title}排行榜',
        backgroundColor: Colors.pink[200],
        icon: const [CustomSearch(icon: Icon(Icons.search), type: "user",)],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (data.isEmpty) {
      return const CustomLoading();
    } else {
      return Stack(
        children: [getItem(), getReturnTop()],
      );
    }
  }

  Widget getItem() {
    return CupertinoScrollbar(
      controller: controller,
      child: ListView.builder(
          controller: controller,
          itemExtent: 100,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent)
              ),
              onPressed: () async {
                UserDetailModel userDetailModel = await GetUserData.getSingleUserData(data[index].uid);
                jumpToUserDetailPage(userDetailModel);
              },
              child: getHead(data[index]),
            );
          }),
    );
  }

  jumpToUserDetailPage(UserDetailModel userDetailModel){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                UserDetail(userDetailModel)));
  }

  Widget getHead(UserModel user) {
    //得到用户头像粉丝等部分
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.2, color: Colors.blueGrey))),
      padding: const EdgeInsets.only(left: 5, bottom: 4, top: 2),
      child: Row(
        children: <Widget>[
          Hero(
            tag: user.picUrl.toString(),
            child: PhysicalModel(
              elevation: 1,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          user.picUrl.toString(),
                        ),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 8),
              alignment: AlignmentDirectional.topStart,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name.toString(),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      "播放量:${user.see}",
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  )
                ],
              )),
          Expanded(
              child: Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.only(right: 3),
            child: Text(
              "粉丝:${user.fan}",
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ))
        ],
      ),
    );
  }

  Widget getReturnTop() {
    return CustomReturnTop(controller: controller,);
  }
}


