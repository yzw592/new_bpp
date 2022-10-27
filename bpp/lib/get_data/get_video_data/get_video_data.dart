import 'dart:convert';

import 'package:leancloud_storage/leancloud.dart';

import '../../model/video_model/video_model.dart';


class GetVideoData {
  static Future getVideoBriefData(String type) async {
    List? res;
    List<VideoBriefModel> videoBriefData = [];
    res = await requestVideoData('data_2022_10_07hotvideo', 'sort', type, 100);
    for (var item in res!) {
      Map<String, dynamic> jsonItem = json.decode(item.toString());
      videoBriefData.add(VideoBriefModel(
          aid: jsonItem['aid'].toString(),
          uid: jsonItem['uid'].toString(),
          comment: jsonItem['comment'].toString(),
          videoName: jsonItem['filename'].toString(),
          videoPicUrl: jsonItem['head'].toString(),
          userName: jsonItem['name'].toString(),
          videoSee: jsonItem['see'].toString(),
          rank: jsonItem['rank'].toString(),
          sort: jsonItem['sort'].toString(),
          videoUrl: jsonItem['url'].toString()));
    }
    return videoBriefData;
  }

  static Future getVideoDetailData(VideoBriefModel videoBriefModel) async {
    VideoDetailModel videoDetailModel;
    var aid = videoBriefModel.aid.toString();
    var bv = videoBriefModel.videoUrl.toString().split("/")[2];
    Map<String, dynamic> jsonVideoDetail = json.decode((await requestVideoData(
            'data_2022_10_07hotvideodetail', 'bv', bv, 1))[0]
        .toString());
    Map<String, dynamic> jsonVideoComment = json.decode((await requestVideoData(
            'data_2022_10_07videocomment', 'aid', aid, 1))[0]
        .toString());
    videoDetailModel = VideoDetailModel(
        aid: videoBriefModel.aid,
        uid: videoBriefModel.uid,
        comment: jsonVideoDetail['comment'].toString(),
        videoName: videoBriefModel.videoName,
        videoPicUrl: videoBriefModel.videoPicUrl,
        userName: videoBriefModel.userName,
        videoSee: videoBriefModel.videoSee,
        rank: videoBriefModel.rank,
        sort: videoBriefModel.sort,
        videoUrl: videoBriefModel.videoUrl,
        coin: jsonVideoDetail['coin'].toString(),
        cTime: jsonVideoDetail['ctime'].toString(),
        barrage: jsonVideoDetail['danmaku'].toString(),
        favorite: jsonVideoDetail['favorite'].toString(),
        videoLike: jsonVideoDetail['like'].toString(),
        detailVideoSee: jsonVideoDetail['see'].toString(),
        videoShare: jsonVideoDetail['share'].toString(),
        detailComment: jsonVideoComment['comment']);
    return videoDetailModel;
  }

  static requestVideoData(
      String tableName, String condition, String key, int returnLimit) async {
    List? res;
    LCQuery<LCObject> query = LCQuery(tableName);
    query.whereEqualTo(condition, key);
    query.limit(returnLimit);
    res = await query.find();
    return res;
  }
}
