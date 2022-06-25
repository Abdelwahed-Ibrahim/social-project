import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../modules/chat/chats_screen.dart';
import '../../modules/news_feed/home_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  var nameController = TextEditingController();

  List<String> titles = [
    'Feed',
    'Chats',
    'Nearby',
    'Profile',
  ];

  List<Widget> screens = const [
    HomeScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  // Map<String ,List<Widget>> action = {};

  void changeNavIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  late UserModel user;

  void getUserInfo() {
    emit(AppGetUserInfoLoadingState());
    FirebaseFirestore.instance.collection('Users').doc(uId).get().then((value) {
      user = UserModel.fromJSON(value.data());
      emit(AppGetUserInfoSuccessState());
      getUserIsLikedPosts();
      getUserImages();
    }).catchError((error) {
      emit(AppGetUserInfoErrorState(error.toString()));
    });
  }

  void verifyEmail() {
    FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) {
      emit(AppSendEmailVerificationSuccessState());
    }).catchError((error) {
      emit(AppSendEmailVerificationErrorState(error.toString()));
    });
  }

  File? profileImage;
  File? coverImage;
  var picker = ImagePicker();

  Future<void> pickProfileImage() async {
    emit(AppPickUserProfileImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppPickUserProfileImageSuccessState());
    } else {
      showToast(message: 'No Image Selected', state: ToastStates.WARNING);
      emit(AppPickUserProfileImageErrorState('No Image Selected'));
    }
  }

  Future<void> pickCoverImage() async {
    emit(AppPickUserCoverImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppPickUserCoverImageSuccessState());
    } else {
      showToast(message: 'No Image Selected', state: ToastStates.WARNING);
      emit(AppPickUserCoverImageErrorState('No Image Selected'));
    }
  }

  String? uploadedCoverUrl;
  String? uploadedProfileUrl;

  void uploadProfileImage() {
    emit(AppUploadUserProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${user.uId}/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadedProfileUrl = value;
        emit(AppSaveProfileImageLinkLoadingState());
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uId)
            .collection('Images')
            .add({
          'url': value,
        }).then((value) {
          profileImage = null;
          emit(AppSaveProfileImageLinkSuccessState());
        }).catchError((error) {
          emit(AppSaveProfileImageLinkErrorState(error.toString()));
        });
        emit(AppUploadUserProfileImageSuccessState());
        updateUserInfo();
      }).catchError((error) {
        emit(AppUploadUserProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(AppUploadUserProfileImageErrorState(error.toString()));
    });
  }

  void uploadCoverImage() {
    emit(AppUploadUserCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${user.uId}/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadedCoverUrl = value;
        emit(AppSaveCoverImageLinkLoadingState());
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uId)
            .collection('Images')
            .add({
          'url': value,
        }).then((value) {
          coverImage = null;
          emit(AppSaveCoverImageLinkSuccessState());
        }).catchError((error) {
          emit(AppSaveCoverImageLinkErrorState(error.toString()));
        });
        emit(AppUploadUserCoverImageSuccessState());
        updateUserInfo();
      }).catchError((error) {
        emit(AppUploadUserCoverImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(AppUploadUserCoverImageErrorState(error.toString()));
    });
  }

  void updateUser({
    String? name,
    String? nickName,
    String? bio,
    String? phone,
  }) {
    if (profileImage != null) {
      uploadProfileImage();
    }
    if (coverImage != null) {
      uploadCoverImage();
    }
    updateUserInfo(
      name: name,
      nickName: nickName,
      bio: bio,
      phone: phone,
    );
    allowEditName = allowEditNickname = allowEditBio = allowEditPhone = false;
  }

  void updateUserInfo({
    String? name,
    String? nickName,
    String? bio,
    String? phone,
  }) {
    emit(AppUpdateUserInfoLoadingState());
    UserModel userModel = UserModel(
      uId: user.uId,
      name: name ?? user.name,
      nickName: nickName ?? user.nickName,
      email: user.email,
      phone: phone ?? user.phone,
      image: uploadedProfileUrl ?? user.image,
      coverImage: uploadedCoverUrl ?? user.coverImage,
      bio: bio ?? user.bio,
      isEmailVerified: user.isEmailVerified,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .update(userModel.toMap())
        .then((value) {
      getUserInfo();
      emit(AppUpdateUserInfoSuccessState());
    }).catchError((error) {
      emit(AppUpdateUserInfoErrorState(error.toString()));
    });
  }

  bool allowEditName = false;
  bool allowEditNickname = false;
  bool allowEditBio = false;
  bool allowEditPhone = false;

  void allowEditingName() {
    allowEditName = !allowEditName;
    emit(AppChangeNameState());
  }

  void allowEditingNickname() {
    allowEditNickname = !allowEditNickname;
    emit(AppChangeNicknameState());
  }

  void allowEditingBio() {
    allowEditBio = !allowEditBio;
    emit(AppChangeBioState());
  }

  void allowEditingPhone() {
    allowEditPhone = !allowEditPhone;
    emit(AppChangePhoneState());
  }

  File? postImage;

  void removePickedImage() {
    postImage = null;
    tempImage = null;
    emit(AppRemovePickedImageSuccessState());
  }

  Future<void> pickPostImage() async {
    emit(AppPickPostImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AppPickPostImageSuccessState());
    } else {
      showToast(message: 'No Image Selected', state: ToastStates.WARNING);
      emit(AppPickPostImageErrorState('No Image Selected'));
    }
  }

  late String uploadedPostImageUrl;

  // void uploadPostImage() {
  //   emit(AppUploadPostImageLoadingState());
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
  //       .putFile(postImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       uploadedPostImageUrl = value;
  //       emit(AppUploadPostImageSuccessState());
  //     }).catchError((error) {
  //       emit(AppUploadPostImageErrorState(error.toString()));
  //     });
  //   }).catchError((error) {
  //     emit(AppUploadPostImageErrorState(error.toString()));
  //   });
  // }

  void uploadPostWithImage({
    required String dateTime,
    required String postText,
  }) {
    emit(AppUploadPostImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadedPostImageUrl = value;
        emit(AppUploadPostImageSuccessState());
        createPost(
          dateTime: dateTime,
          postText: postText,
          postImage: value,
        );
      }).catchError((error) {
        emit(AppUploadPostImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(AppUploadPostImageErrorState(error.toString()));
    });
  }

  void createPost({
    required String dateTime,
    required String postText,
    String? postImage,
  }) {
    emit(AppCreatePostLoadingState());
    PostModel post = PostModel(
      userName: user.name,
      userID: user.uId,
      userImage: user.image,
      dateTime: dateTime,
      postText: postText,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('Posts')
        .add(post.toMap())
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostErrorState(error.toString()));
    });
  }

  Map<String, PostModel> posts = {};
  Map<String, int> postsLikes = {};
  Map<String, int> postsComments = {};
  Map<String, List<CommentModel>?> comments = {};
  Map<String, List<UserModel>?> allPostsLikes = {};

  void getAllPosts() {
    emit(AppGetPostsLoadingState());
    FirebaseFirestore.instance.collection('Posts').snapshots().listen((event) {
      posts = {};
      postsLikes = {};
      postsComments = {};
      for (var element in event.docs) {
        element.reference.collection('Likes').get().then((value) {
          postsLikes[element.id] = value.docs.length;
          element.reference.collection('Comments').get().then((value) {
            postsComments[element.id] = value.docs.length;
            comments[element.id] = getPostComments(element.id);
            allPostsLikes[element.id] = getPostLikes(element.id);
            posts[element.id] = PostModel.fromJSON(element.data());
          }).catchError((error) {
            emit(AppGetPostsErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(AppGetPostsErrorState(error.toString()));
        });
        emit(AppGetPostsSuccessState());
      }
      getUserIsLikedPosts();
    });
  }

  void likePost(String postId) {
    emit(AppLikePostLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .doc(user.uId)
        .get()
        .then((value) {
      if (value.data() == null || value.data()!['like'] == false) {
        value.reference.set({
          'like': true,
        }).then((value) {
          emit(AppLikePostSuccessState());
          getAllPosts();
          getAllUserPosts();
        }).catchError((error) {
          emit(AppLikePostErrorState(error.toString()));
        });
      } else if (value.data()!['like'] == true) {
        value.reference.delete();
        emit(AppDislikePostSuccessState());
        getAllPosts();
        getAllUserPosts();
      }
    }).catchError((error) {
      emit(AppLikePostErrorState(error.toString()));
    });
  }

  void postComment(String postId, String comment) {
    emit(AppCommentOnPostLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .add({
      'userId': user.uId,
      'comment': comment,
      'dateTime': DateFormat('MMMM d, yyyy At h:mm a')
          .format(DateTime.now())
          .toString(),
    }).then((value) {
      emit(AppCommentOnPostSuccessState());
      getAllPosts();
      getAllUserPosts();
    }).catchError((error) {
      emit(AppCommentOnPostErrorState(error.toString()));
    });
  }

  List<CommentModel> getPostComments(String postId) {
    List<CommentModel> postComments = [];
    emit(AppGetPostCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        // Get User Info by UserId
        UserModel? commentUser;
        FirebaseFirestore.instance
            .collection('Users')
            .doc(element.data()['userId'])
            .get()
            .then((value) {
          commentUser = UserModel.fromJSON(value.data());
          CommentModel model = CommentModel(
            comment: element.data()['comment'],
            dateTime: element.data()['dateTime'],
            userName: commentUser!.name,
            userImage: commentUser!.image,
          );
          postComments.add(model);
          emit(AppGetPostCommentsSuccessState());
        }).catchError((error) {
          emit(AppGetPostCommentsErrorState(error.toString()));
        });
        // UserId = element.id
      }
    }).catchError((error) {
      emit(AppGetPostCommentsErrorState(error.toString()));
    });
    return postComments;
  }

  Map<String, PostModel> userPosts = {};
  Map<String, int> userPostsLikes = {};
  Map<String, int> userPostsComments = {};
  Map<String, List<CommentModel>?> userComments = {};

  void getAllUserPosts() {
    emit(AppGetUserPostsLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .where('userID', isEqualTo: user.uId)
        .snapshots()
        .listen((event) {
      userPosts = {};
      userPostsLikes = {};
      userPostsComments = {};
      for (var element in event.docs) {
        element.reference.collection('Likes').get().then((value) {
          userPostsLikes[element.id] = value.docs.length;
          element.reference.collection('Comments').get().then((value) {
            userPostsComments[element.id] = value.docs.length;
            userComments[element.id] = getPostComments(element.id);

            userPosts[element.id] = PostModel.fromJSON(element.data());
          }).catchError((error) {
            emit(AppGetUserPostsErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(AppGetUserPostsErrorState(error.toString()));
        });
        emit(AppGetUserPostsSuccessState());
      }
    });
  }

  bool allowSendComment = false;

  void allowSendingComment(String value) {
    if (value.isNotEmpty) {
      allowSendComment = true;
    } else {
      allowSendComment = false;
    }
    emit(AppSendCommentState());
  }

  Map<String, bool> userPostsIsLiked = {};

  void getUserIsLikedPosts() {
    emit(AppGetUserIsLikedPostsLoadingState());
    userPostsIsLiked = {};
    FirebaseFirestore.instance.collection('Posts').snapshots().listen((event) {
      for (var element in event.docs) {
        element.reference.collection('Likes').doc(user.uId).get().then((value) {
          if (value.data() != null) {
            userPostsIsLiked[element.id] = true;
          } else {
            userPostsIsLiked[element.id] = false;
          }
          emit(AppGetUserIsLikedPostsSuccessState());
        }).catchError((error) {
          emit(AppGetUserIsLikedPostsErrorState(error.toString()));
        });
      }
    });
  }

  List<UserModel> getPostLikes(String postId) {
    emit(AppGetPostLikesLoadingState());
    List<UserModel> postLikes = [];
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        //UserId is element.id
        FirebaseFirestore.instance
            .collection('Users')
            .doc(element.id)
            .get()
            .then((value) {
          UserModel model = UserModel.fromJSON(value.data());
          postLikes.add(model);
          emit(AppGetPostLikesSuccessState());
        }).catchError((error) {
          emit(AppGetPostLikesErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(AppGetPostLikesErrorState(error.toString()));
    });
    return postLikes;
  }

  File? tempImage;

  Future<void> pickTempImage() async {
    emit(AppPickTempImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      tempImage = File(pickedFile.path);
      emit(AppPickTempImageSuccessState());
    } else {
      showToast(message: 'No Image Selected', state: ToastStates.WARNING);
      emit(AppPickTempImageErrorState('No Image Selected'));
    }
  }

  void uploadTempImage() {
    emit(AppUploadTempImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${user.uId}/${Uri.file(tempImage!.path).pathSegments.last}')
        .putFile(tempImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(AppSaveTempImageLinkLoadingState());
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uId)
            .collection('Images')
            .add({
          'url': value,
        }).then((value) {
          tempImage = null;
          emit(AppSaveTempImageLinkSuccessState());
        }).catchError((error) {
          emit(AppSaveTempImageLinkErrorState(error.toString()));
        });
        emit(AppUploadTempImageSuccessState());
      }).catchError((error) {
        emit(AppUploadTempImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(AppUploadTempImageErrorState(error.toString()));
    });
  }

  List<String> images = [];

  void getUserImages() {
    images = [];
    emit(AppGetUserImagesLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uId)
        .collection('Images')
        .get()
        .then((value) {
      for (var element in value.docs) {
        images.add(element.data()['url']);
      }
      emit(AppGetUserImageSuccessState());
    }).catchError((error) {
      emit(AppGetUserImagesErrorState(error.toString()));
    });
  }

  Widget? widget;

  void setState() {
    emit(AppGeneralState());
  }
}
