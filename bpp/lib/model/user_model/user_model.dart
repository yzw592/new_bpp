class UserModel {
  String uid;
  String name;
  String picUrl;
  String care;
  String good;
  String level;
  String sex;
  String sign;
  String vip;
  String fan;
  String see;

  UserModel(
      {required this.uid,
      required this.name,
      required this.picUrl,
      required this.care,
      required this.fan,
      required this.good,
      required this.level,
      required this.see,
      required this.sex,
      required this.sign,
      required this.vip});
}

class UserDetailModel extends UserModel {
  final List totalVideo;
  final List sortVideo;

  UserDetailModel(
      {required super.uid,
      required super.name,
      required super.picUrl,
      required super.care,
      required super.fan,
      required super.good,
      required super.level,
      required super.see,
      required super.sex,
      required super.sign,
      required super.vip,
      required this.totalVideo,
      required this.sortVideo});
}
