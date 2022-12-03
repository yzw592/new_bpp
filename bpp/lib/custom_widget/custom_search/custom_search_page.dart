import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bppnew/get_data/get_user_data/get_user_data.dart';
import 'package:bppnew/get_data/get_video_data/get_video_data.dart';
import 'package:bppnew/model/user_model/user_model.dart';
import 'package:bppnew/model/video_model/video_model.dart';
import 'package:bppnew/user/user_detail.dart';
import 'package:bppnew/video/video_detail.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSearchPage extends StatefulWidget {
  final String type;
  const CustomSearchPage({Key? key, required this.type}) : super(key: key);

  @override
  State<CustomSearchPage> createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage> {
  TextEditingController textEditingController = TextEditingController();
  StreamController streamController = StreamController();
  List data = [];
  List<UserModel> searchUserData = [];
  List<UserModel> preSearchUserData = [];
  List<VideoBriefModel> searchVideoData = [];
  List<VideoBriefModel> preSearchVideoData = [];
  List<UserModel> hotUserRecommend = [];
  List<VideoBriefModel> hotVideoRecommend = [];
  bool flag = true;
  List<String> history = [];
  String wordCount = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
    if (widget.type == "user") {
      //用户数据
      GetUserData.getUserData("播放量").then((value) {
        data = value;
        setState(() {});
      });
    } else {
      //视频数据
      GetVideoData.getVideoBriefData("all").then((value) {
        data = value;
        setState(() {});
      });
    }

    streamController.stream.listen((event) {
      if (event > 0) {
        setState(() {
          if (widget.type == "user") {
            searchUserData.sort((a, b) =>
                -int.parse(a.fan.toString()) + int.parse(b.fan.toString()));
            preSearchUserData = searchUserData;
            searchUserData = [];
          } else {
            preSearchVideoData = searchVideoData;
            searchVideoData = [];
          }
        });
      }
      if (event == 0) {
        if (widget.type == "user") {
          preSearchUserData = [];
          searchUserData = [];
        } else {
          preSearchVideoData = [];
          searchVideoData = [];
        }
        setState(() {});
      }
      flag = preSearchUserData.length + preSearchVideoData.length == 0
          ? true
          : false;
    });
  }

  Future<void> getHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    history = sharedPreferences.getStringList("historySearch")!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ...getSearchWidget(),
            ],
          ), //搜索栏
          futureLoadingSearchData(), //搜索数据
        ],
      ),
    ));
  }

  List<Widget> getSearchWidget() {
    return [
      Container(
          width: MediaQuery.of(context).size.width,
          height: 95,
          color: Colors.grey[300],
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            color: Colors.grey[300],
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Autocomplete(
                    fieldViewBuilder: buildFiledView,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return history;
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    child: const Text("取消"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          )),
    ];
  }

  Widget buildFiledView(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    textEditingController = this.textEditingController;
    return SizedBox(
      height: 34,
      child: TextFormField(
        controller: textEditingController,
        focusNode: focusNode,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          fillColor: Color(0xFFF7F8FA),
          prefixIcon: Icon(Icons.search),
          filled: true,
          contentPadding: EdgeInsets.only(top: 1.0),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(19.0),
            ),
          ),
        ),
        onFieldSubmitted: (String value) {
          getSearchData();
        },
      ),
    );
  }

  // List<Widget> getSearchWidget() {
  //   return [
  //     Container(
  //       //搜索栏
  //       width: MediaQuery.of(context).size.width - 64,
  //       margin: const EdgeInsets.only(top: 25),
  //       padding: const EdgeInsets.only(left: 8),
  //       child: TextField(
  //         controller: textEditingController,
  //         maxLines: 1,
  //         decoration: InputDecoration(
  //             hintText: "请输人搜索内容",
  //             prefixIcon: IconButton(
  //               icon: const Icon(Icons.search, color: Colors.black),
  //               onPressed: () {
  //                 getSearchData();
  //               },
  //             ),
  //             suffixIcon: IconButton(
  //               icon: const Icon(
  //                 Icons.clear,
  //                 color: Colors.black,
  //               ),
  //               onPressed: () {
  //                 textEditingController.clear();
  //               },
  //             ),
  //             isDense: true,
  //             border: const OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)))),
  //       ),
  //     ),
  //     Padding(
  //         //取消按钮
  //         padding: const EdgeInsets.only(top: 25),
  //         child: TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text(
  //               "取消",
  //               style: TextStyle(fontSize: 16, color: Colors.black),
  //             )))
  //   ];
  // } //搜索栏

  Widget historyBody() {
    List<Widget> rowItem = [];
    int count = 0;
    if (history.length != 1) {
      for (int i = 0; i < history.length ~/ 2; i++) {
        rowItem.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Draggable(
              feedback: Container(
                width: 50,
                height: 50,
                color: Colors.blueGrey,
              ),
              child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    history[count],
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            Container(
                width: 100,
                margin: const EdgeInsets.only(bottom: 5),
                child: Text(
                  history[count + 1],
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ));
        count = count + 2;
      }
    }
    if (history.length % 2 != 0) {
      rowItem.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: 100,
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                history[count],
                overflow: TextOverflow.ellipsis,
              )),
          Container(
              width: 100,
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(""))
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rowItem,
    );
  }

  Future<String> loadingData() async {
    await Future.delayed(const Duration(seconds: 1));
    return "ok";
  }

  futureLoadingSearchData() {
    if (!flag) {
      return FutureBuilder(
        future: loadingData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return getList();
          } else {
            return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                child: const CircularProgressIndicator());
          }
        },
      );
    } else {
      return hotRecommend();
    }
  }

  Widget hotRecommend() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchWordCount(),
          const Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 20),
              child: Text("热门推荐")),
          const Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 5),
              child: Divider(
                thickness: 2,
              )),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {
                      hotUserRecommend = [];
                      hotVideoRecommend = [];
                    });
                  },
                  child: getRecommendBody())),
        ],
      ),
    );
  } //热门推荐

  Widget searchWordCount() {
    if (wordCount == "") {
      return GestureDetector(
        child: Icon(Icons.search),
        onTap: () async {
          debugPrint("搜索");
          LCQuery<LCObject> query = LCQuery('_File');
          query.whereEqualTo("name", "985995573.png");
          List a = await query.find() as List;
          setState(() {
            wordCount = jsonDecode(a[0].toString())['url'];
          });
        },
      );
    } else {
      return AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: 300,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: PhysicalModel(
            elevation: 4, color: Colors.white, child: Image.network(wordCount)),
      );
    }
  }

  Widget getList() {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.type == "user"
              ? preSearchUserData.length
              : preSearchVideoData.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.2, color: Colors.black))),
              child: getListBody(index),
            );
          }),
    );
  }

  Widget getListBody(int index) {
    if (widget.type == "user") {
      return GestureDetector(
        child: ListTile(
          title: Text(preSearchUserData[index].name),
          leading: Hero(
              tag: preSearchUserData[index].picUrl,
              child: PhysicalModel(
                  elevation: 4,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(preSearchUserData[index].picUrl)))),
          trailing: Text("粉丝:${preSearchUserData[index].fan}"),
          subtitle: Text(preSearchUserData[index].uid),
        ),
        onTap: () async {
          UserDetailModel userDetailModel =
              await GetUserData.getSingleUserData(preSearchUserData[index].uid);
          jumpToDetailPage(userDetailModel: userDetailModel);
        },
      );
    } else {
      return GestureDetector(
        child: ListTile(
          title: Text(
            preSearchVideoData[index].videoName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Hero(
              tag: preSearchVideoData[index].videoPicUrl,
              child: PhysicalModel(
                  elevation: 4,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://${preSearchVideoData[index].videoPicUrl}',
                      fit: BoxFit.cover,
                    ),
                  ))),
          trailing: Column(
            children: [
              Text("播放量:${preSearchVideoData[index].videoSee}"),
              Text(
                  "${preSearchVideoData[index].sort}榜:第${preSearchVideoData[index].rank}名")
            ],
          ),
          subtitle: Text("发布者:${preSearchVideoData[index].userName}"),
        ),
        onTap: () {
          jumpToDetailPage(videoBriefModel: preSearchVideoData[index]);
        },
      );
    }
  } //搜索的元素展示

  jumpToDetailPage(
      {UserDetailModel? userDetailModel, //页面跳转
      VideoBriefModel? videoBriefModel}) {
    if (widget.type == "user") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => UserDetail(userDetailModel!)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => VideoDetail(videoBriefModel!)));
    }
  }

  Future<void> getSearchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (widget.type == "user" && textEditingController.text != "") {
      for (var element in (data as List<UserModel>)) {
        if (element.name
            .toUpperCase()
            .contains(textEditingController.text.toUpperCase())) {
          searchUserData.add(element);
        }
      }
      history.add(textEditingController.text);
      streamController.sink.add(searchUserData.length);
      if (history.length > 8) {
        List<String> temp = [];
        for (int i = 1; i < history.length; i++) {
          temp.add(history[i]);
        }
        history = temp;
      }
      await sharedPreferences.setStringList("historySearch", history);
    } else {
      if (textEditingController.text != "") {
        List<String> filter = [];
        for (var element in (data as List<VideoBriefModel>)) {
          if (element.videoName
              .toUpperCase()
              .contains(textEditingController.text.toUpperCase())) {
            if (!filter.contains(element.userName)) {
              searchVideoData.add(element);
              filter.add(element.userName);
            }
          }
        }
        streamController.sink.add(searchVideoData.length);
        history.add(textEditingController.text);
        if (history.length > 8) {
          List<String> temp = [];
          for (int i = 1; i < history.length; i++) {
            temp.add(history[i]);
          }
          history = temp;
        }
      }
      await sharedPreferences.setStringList("historySearch", history);
    }
    if (textEditingController.text == "") streamController.sink.add(0);
  } //搜索数据

  Widget getRecommendBody() {
    if (widget.type == 'user' && data.isNotEmpty) {
      List<String> filter = [];
      if (hotUserRecommend.isEmpty) {
        while (hotUserRecommend.length < 10) {
          UserModel tempUser = data[Random().nextInt(1000)] as UserModel;
          if (!filter.contains(tempUser.name)) {
            filter.add(tempUser.name);
            hotUserRecommend.add(tempUser);
          }
        }
      }
      return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return getRecommendUserItem(hotUserRecommend[index]);
          });
    } else if (widget.type == 'video' && data.isNotEmpty) {
      List<String> filter = [];
      if (hotVideoRecommend.isEmpty) {
        while (hotVideoRecommend.length < 10) {
          VideoBriefModel tempUser =
              data[Random().nextInt(1000)] as VideoBriefModel;
          if (!filter.contains(tempUser.videoName)) {
            filter.add(tempUser.videoName);
            hotVideoRecommend.add(tempUser);
          }
        }
      }
      return ListView.builder(
          itemCount: 10,
          itemExtent: 80,
          itemBuilder: (BuildContext context, int index) {
            return getRecommendVideoItem(hotVideoRecommend[index]);
          });
    } else {
      return Container();
    }
  } //构造热门推荐

  Widget getRecommendUserItem(UserModel preSearchUserData) {
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.3, color: Colors.black))),
        child: ListTile(
          title: Text(preSearchUserData.name),
          leading: Hero(
              tag: preSearchUserData.picUrl,
              child: PhysicalModel(
                  elevation: 4,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(preSearchUserData.picUrl)))),
          trailing: Text("粉丝:${preSearchUserData.fan}"),
          subtitle: Text(preSearchUserData.uid),
        ),
      ),
      onTap: () async {
        UserDetailModel userDetailModel =
            await GetUserData.getSingleUserData(preSearchUserData.uid);
        jumpToDetailPage(userDetailModel: userDetailModel);
      },
    );
  } //热门数据的用户列表

  Widget getRecommendVideoItem(VideoBriefModel preSearchVideoData) {
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.3, color: Colors.black))),
        child: ListTile(
          title: Text(
            preSearchVideoData.videoName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          leading: PhysicalModel(
              elevation: 4,
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://${preSearchVideoData.videoPicUrl}',
                  fit: BoxFit.cover,
                ),
              )),
          trailing: Column(
            children: [
              Text("播放量:${preSearchVideoData.videoSee}"),
              Text("${preSearchVideoData.sort}榜:第${preSearchVideoData.rank}名")
            ],
          ),
          subtitle: Text(
            "发布者:${preSearchVideoData.userName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      onTap: () {
        jumpToDetailPage(videoBriefModel: preSearchVideoData);
      },
    );
  } //热门数据的视频列表
}
