class PostModel {
  String? userName;
  String? userID;
  String? userImage;
  String? dateTime;

  // String? postId;
  String? postText;
  String? postImage;

  PostModel({
    required this.userName,
    required this.userID,
    required this.userImage,
    required this.dateTime,
    // required this.postId,
    required this.postText,
    this.postImage,
  });

  PostModel.fromJSON(Map<String, dynamic> json) {
    userName = json['userName'];
    userID = json['userID'];
    userImage = json['userImage'];
    dateTime = json['dateTime'];
    // postId = json['postId'];
    postText = json['postText'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userID': userID,
      'userImage': userImage,
      'dateTime': dateTime,
      // 'postId': postId,
      'postText': postText,
      'postImage': postImage,
    };
  }
}
