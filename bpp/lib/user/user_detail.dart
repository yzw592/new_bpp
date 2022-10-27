import 'package:bppnew/custom_widget/custom_get_sex/custom_get_sex.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../custom_widget/custom_appbar/custom_appbar.dart';
import '../custom_widget/custom_border/custom_border.dart';
import '../custom_widget/custom_loading/custom_loading.dart';
import '../custom_widget/custom_sign/custom_sign.dart';
import '../custom_widget/custom_tabbar/custom_user_tabbar.dart';
import '../get_data/get_user_data/get_user_data.dart';
import '../model/user_model/user_model.dart';
import '../model/user_model/user_week_data.dart';


class UserDetail extends StatefulWidget {
  final UserModel user;

  const UserDetail(this.user, {super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  UserWeekData? userWeekData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUserData.getChartData(widget.user.uid.toString()).then((value) {
      setState(() {
        userWeekData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "up主详情页面",
        backgroundColor: Color(0xFFF48FB1),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getHead(), //得到头像
            getDetail(), //得到身份认证vip等信息
          ],
        ),
        getData(), //得到uid 粉丝 播放量等数据
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: CustomSign(
              sign: "个性签名:${widget.user.sign}",
              maxWidth: 15,
            )), //得到个人签名
        const CustomBorder(),
        Container(
            margin: const EdgeInsets.only(top: 10),
            child: getCustomerTabBar()), //图表的数据纬度导航栏
      ],
    );
  }

  Widget getHead() {
    return Container(
        margin: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(35)),
          image: DecorationImage(
              image: NetworkImage(widget.user.picUrl.toString())),
        ));
  }

  Widget getDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getNameAndSex(), //得到姓名和性别信息
        getIdentity(), //得到身份认证
        getLevelAndVip(), //得到等级和vip,
      ],
    );
  }

  Widget getNameAndSex() {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: Text(
            widget.user.name.toString(),
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
        CustomGetSex(sex: widget.user.sex, left: 5 ,top: 15, size: 15,)
      ],
    );
  }
  
  Widget getIdentity() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        "这是up的身份认证",
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    );
  }

  Widget getLevelAndVip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Text(
            "等级:${widget.user.level}",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        getVip() //得到vip等级
      ],
    );
  }

  Widget getVip() {
    if (widget.user.vip != '否') {
      return Container(
        width: 80,
        height: 30,
        padding: const EdgeInsets.only(left: 8, top: 5),
        child: Image.asset(
          'assets/images/${widget.user.vip}.webp',
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getData() {
    return Row(
      children: <Widget>[
        getUid(), //uid
        getFan(), //粉丝
        getSee(), //播放量
      ],
    );
  }

  Widget getUid() {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: Text(
        "uid:${widget.user.uid}",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget getFan() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 5),
      child: Text(
        "粉丝量:${widget.user.fan}",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget getSee() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 5),
      child: Text(
        "播放量:${widget.user.see}",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget getCustomerTabBar() {
    if (userWeekData == null) {
      return const Center(
        child: CustomLoading(),
      );
    } else {
      return CustomTabBar(userWeekData!);
    }
  }
}
