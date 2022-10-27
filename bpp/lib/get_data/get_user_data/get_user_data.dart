import 'dart:convert';

import 'package:leancloud_storage/leancloud.dart';

import '../../model/user_model/user_model.dart';
import '../../model/user_model/user_week_data.dart';

class GetUserData {
  static Future getUserData(String sortFlag) async {
    List? res;
    List<UserModel> userData = [];
    LCQuery<LCObject> query = LCQuery('data_2022_10_07hotuser');
    query.limit(1000);
    res = await query.find();
    for (var item in res!) {
      Map<String, dynamic> jsonItem = json.decode(item.toString());
      userData.add(UserModel(
          uid: jsonItem['uid'].toString(),
          name: jsonItem['name'],
          picUrl: jsonItem['head'],
          care: jsonItem['care'].toString(),
          fan: jsonItem['fan'].toString(),
          good: jsonItem['good'].toString(),
          level: jsonItem['level'].toString(),
          see: jsonItem['see'].toString(),
          sex: jsonItem['sex'],
          sign: jsonItem['sign'],
          vip: jsonItem['vip']));
    }
    userData = await userSort(sortFlag, userData);
    return userData;
  }

  static Future getSingleUserData(String uid) async {
    UserDetailModel userDetailModel;
    LCQuery<LCObject> query = LCQuery('data_2022_10_07hotuser');
    query.whereEqualTo('uid', int.parse(uid));
    var item = await query.find();
    Map<String, dynamic> jsonItem = json.decode(item![0].toString());
    query = LCQuery('data_2022_10_07usertotalvideo');
    query.whereEqualTo('uid', uid);
    var itemVideo = await query.find();
    Map<String, dynamic> jsonVideoItem = json.decode(itemVideo![0].toString());
    userDetailModel = UserDetailModel(
        uid: jsonItem['uid'].toString(),
        name: jsonItem['name'],
        picUrl: jsonItem['head'],
        care: jsonItem['care'].toString(),
        fan: jsonItem['fan'].toString(),
        good: jsonItem['good'].toString(),
        level: jsonItem['level'].toString(),
        see: jsonItem['see'].toString(),
        sex: jsonItem['sex'],
        sign: jsonItem['sign'],
        vip: jsonItem['vip'],
        totalVideo: jsonVideoItem['video'],
        sortVideo: jsonVideoItem['sort']);

    return userDetailModel;
  }

  static Future userSort(String sortFlag, List<UserModel> userData) async {
    if (sortFlag == '播放量') {
      userData.sort(
          (a, b) => int.parse(b.see.toString()) - int.parse(a.see.toString()));
      return userData;
    } else if (sortFlag == '播放量增量') {
      return await getUserAddDataOrMinData(sortFlag, userData);
    } else if (sortFlag == '粉丝') {
      userData.sort(
          (a, b) => int.parse(b.fan.toString()) - int.parse(a.fan.toString()));
      return userData;
    } else if (sortFlag == '涨粉') {
      return await getUserAddDataOrMinData(sortFlag, userData);
    } else if (sortFlag == '掉粉') {
      return await getUserAddDataOrMinData(sortFlag, userData);
    }
  }

  static Future getUserAddDataOrMinData(
      String sortFlag, List<UserModel> userData) async {
    Map<String, String> type = {'播放量增量': 'see', '涨粉': 'fan', '掉粉': '-fan'};
    Map<String, String> preJsonData = {};
    List<UserModel> countData = [];
    LCQuery<LCObject> pre = LCQuery('data_2022_10_06hotuser');
    pre.limit(1000);
    final List? res = await pre.find();
    for (var item in res!) {
      preJsonData[item['uid'].toString()] =
          item[type[sortFlag]!.replaceAll('-', '')].toString();
    }
    for (var item in userData) {
      if (preJsonData[item.uid.toString()] != null) {
        if (type[sortFlag] == 'see') {
          item.see = (int.parse(item.see.toString()) -
                  int.parse(preJsonData[item.uid.toString()]!))
              .toString();
        } else {
          item.fan = (int.parse(item.fan.toString()) -
                  int.parse(preJsonData[item.uid.toString()]!))
              .toString();
        }
      } else {
        if (type[sortFlag] == 'see') {
          item.see = '0';
        } else {
          item.fan = '0';
        }
      }
      countData.add(item);
    }
    userData = countData;
    if (type[sortFlag] == 'see') {
      userData.sort(
          (a, b) => int.parse(b.see.toString()) - int.parse(a.see.toString()));
    } else if (type[sortFlag] == 'fan') {
      userData.sort(
          (a, b) => int.parse(b.fan.toString()) - int.parse(a.fan.toString()));
    } else {
      userData.sort(
          (a, b) => int.parse(a.fan.toString()) - int.parse(b.fan.toString()));
    }
    return userData;
  }

  static Future getChartData(String uid) async {
    UserWeekData data;
    List<int> seeData = [];
    List<int> careData = [];
    List<int> fanData = [];
    List<int> goodData = [];
    for (int i = 1; i <= 8; i++) {
      LCQuery<LCObject> query = LCQuery('data_2022_10_0${i}hotuser');
      query.whereEqualTo('uid', int.parse(uid));
      var queryFind = await query.find();
      seeData.add(int.parse(queryFind![0]['see'].toString()));
      careData.add(int.parse(queryFind[0]['care'].toString()));
      fanData.add(int.parse(queryFind[0]['fan'].toString()));
      goodData.add(int.parse(queryFind[0]['good'].toString()));
    }
    data = UserWeekData(seeData, goodData, fanData, careData);
    return data;
  }
}
