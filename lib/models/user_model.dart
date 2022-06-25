class UserModel {
  String? uId;
  String? name;
  String? nickName;
  String? email;
  String? phone;
  String? bio;
  String? image;
  String? coverImage;
  bool? isEmailVerified;

  UserModel({
    this.uId,
    this.name,
    this.nickName,
    this.email,
    this.phone,
    this.bio,
    this.image,
    this.coverImage,
    this.isEmailVerified,
  });

  UserModel.fromJSON(Map<String, dynamic>? json) {
    uId = json?['uId'];
    name = json?['name'];
    nickName = json?['nickName'];
    email = json?['email'];
    phone = json?['phone'];
    bio = json?['bio'];
    image = json?['image'];
    coverImage = json?['coverImage'];
    isEmailVerified = json?['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'nickName': nickName,
      'email': email,
      'phone': phone,
      'bio': bio,
      'image': image,
      'coverImage': coverImage,
      'isEmailVerified': isEmailVerified,
    };
  }
}
