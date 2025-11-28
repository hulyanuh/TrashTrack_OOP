class UserInfoModel {
  final String userInfoId;
  final String fname;
  final String lname;
  final String location;
  final String authUserId;
  final String? phoneNum;
  final String? profileImg;

  UserInfoModel({
    required this.userInfoId,
    required this.fname,
    required this.lname,
    required this.location,
    this.phoneNum,
    this.profileImg,
    required this.authUserId,

  });

  Map<String, dynamic> toMap() {
    return {
      'user_info_id': userInfoId,
      'user_fname': fname,
      'user_lname': lname,
      'user_location': location,
      'user_phone_num': phoneNum,
      'user_profile_img': profileImg,
      'auth_user_id': authUserId

    };
  }
}
