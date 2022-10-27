class VideoBriefModel {
  String aid;
  String uid;
  String comment;
  String videoName;
  String videoPicUrl;
  String userName;
  String videoSee;
  String rank;
  String sort;
  String videoUrl;
  VideoBriefModel(
      {required this.aid,
      required this.uid,
      required this.comment,
      required this.videoName,
      required this.videoPicUrl,
      required this.userName,
      required this.videoSee,
      required this.rank,
      required this.sort,
      required this.videoUrl});
}


class VideoDetailModel extends VideoBriefModel {
  String coin;
  String cTime;
  String barrage;
  String favorite;
  String videoLike;
  String detailVideoSee;
  String videoShare;
  List detailComment;

  VideoDetailModel(
      {required super.aid,
      required super.uid,
      required super.comment,
      required super.videoName,
      required super.videoPicUrl,
      required super.userName,
      required super.videoSee,
      required super.rank,
      required super.sort,
      required super.videoUrl,
      required this.coin,
      required this.cTime,
      required this.barrage,
      required this.favorite,
      required this.videoLike,
      required this.detailVideoSee,
      required this.videoShare,
      required this.detailComment});
}
