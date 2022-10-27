import 'package:bppnew/custom_widget/custom_drawer/rank_drawer/rank_drawer.dart';
import 'package:flutter/material.dart';

import 'config_drawer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Column(
          children: <Widget>[
            getDrawerHead(), //抽屉头
            const RankDrawer(rankName: '用户排行榜', rankList: USER_SORT), //用户排行榜
            const Expanded(
                child: RankDrawer(
              rankName: '视频排行榜',
              rankList: VIDEO_SORT,
              rankHeadIcon: Icons.star_outline_rounded,
              rankItemIcon: Icons.star_outline,
            )), //视频排行榜
          ],
        ),
      ),
    );
  }

  Widget getDrawerHead() {
    //得到抽屉头图片
    return SizedBox(
      width: 250,
      child: DrawerHeader(
        decoration: BoxDecoration(
            color: Colors.pink[200],
            image: const DecorationImage(
                image: AssetImage('./assets/images/drawerheader.gif'),
                fit: BoxFit.contain)),
        child: const Text("Bdata"),
      ),
    );
  }
}
