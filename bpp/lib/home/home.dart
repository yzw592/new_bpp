import 'package:flutter/material.dart';

import '../user/user_list_item.dart';

class Home extends StatelessWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: UserListItem('播放量'),
    ));
  }
}
