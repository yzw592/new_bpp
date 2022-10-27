import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'home/home.dart';

void main() {
  initLeanCloud();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

//初始化LeanCloud
void initLeanCloud(){
  LeanCloud.initialize(
      'uxvEB5k8jvRUD4tqTL2xwXer-gzGzoHsz', 'NUU1JHafR0eNyFFgpEu2Op9S',
      server: 'https://uxveb5k8.lc-cn-n1-shared.com',
      queryCache: LCQueryCache());
  LCLogger.setLevel(LCLogger.DebugLevel);
}