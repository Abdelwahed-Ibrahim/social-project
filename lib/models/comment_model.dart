class CommentModel {
  String? userName;
  String? userImage;
  String? comment;
  String? dateTime;

  CommentModel({
    this.userName,
    this.userImage,
    this.comment,
    this.dateTime,
  });

  CommentModel.fromJSON(Map<String, dynamic> json) {
    userName = json['userName'];
    userImage = json['userImage'];
    comment = json['comment'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userImage': userImage,
      'comment': comment,
      'dateTime': dateTime,
    };
  }
}
