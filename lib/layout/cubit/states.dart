abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeNavBarState extends AppStates {}

class AppChangeNameState extends AppStates {}

class AppChangeNicknameState extends AppStates {}

class AppChangeBioState extends AppStates {}

class AppChangePhoneState extends AppStates {}

class AppSendEmailVerificationSuccessState extends AppStates {}

class AppSendEmailVerificationErrorState extends AppStates {
  final String error;

  AppSendEmailVerificationErrorState(this.error);
}

class AppGetUserInfoLoadingState extends AppStates {}

class AppGetUserInfoSuccessState extends AppStates {}

class AppGetUserInfoErrorState extends AppStates {
  final String error;

  AppGetUserInfoErrorState(this.error);
}

class AppPickUserProfileImageLoadingState extends AppStates {}

class AppPickUserProfileImageSuccessState extends AppStates {}

class AppPickUserProfileImageErrorState extends AppStates {
  final String error;

  AppPickUserProfileImageErrorState(this.error);
}

class AppPickUserCoverImageLoadingState extends AppStates {}

class AppPickUserCoverImageSuccessState extends AppStates {}

class AppPickUserCoverImageErrorState extends AppStates {
  final String error;

  AppPickUserCoverImageErrorState(this.error);
}

class AppUploadUserProfileImageLoadingState extends AppStates {}

class AppUploadUserProfileImageSuccessState extends AppStates {}

class AppUploadUserProfileImageErrorState extends AppStates {
  final String error;

  AppUploadUserProfileImageErrorState(this.error);
}

class AppSaveProfileImageLinkLoadingState extends AppStates {}

class AppSaveProfileImageLinkSuccessState extends AppStates {}

class AppSaveProfileImageLinkErrorState extends AppStates {
  final String error;

  AppSaveProfileImageLinkErrorState(this.error);
}

class AppSaveCoverImageLinkLoadingState extends AppStates {}

class AppSaveCoverImageLinkSuccessState extends AppStates {}

class AppSaveCoverImageLinkErrorState extends AppStates {
  final String error;

  AppSaveCoverImageLinkErrorState(this.error);
}

class AppUploadUserCoverImageLoadingState extends AppStates {}

class AppUploadUserCoverImageSuccessState extends AppStates {}

class AppUploadUserCoverImageErrorState extends AppStates {
  final String error;

  AppUploadUserCoverImageErrorState(this.error);
}

class AppUpdateUserInfoLoadingState extends AppStates {}

class AppUpdateUserInfoSuccessState extends AppStates {}

class AppUpdateUserInfoErrorState extends AppStates {
  final String error;

  AppUpdateUserInfoErrorState(this.error);
}

// Create Post States

class AppPickPostImageLoadingState extends AppStates {}

class AppPickPostImageSuccessState extends AppStates {}

class AppPickPostImageErrorState extends AppStates {
  final String error;

  AppPickPostImageErrorState(this.error);
}

class AppRemovePickedImageSuccessState extends AppStates {}

class AppUploadPostImageLoadingState extends AppStates {}

class AppUploadPostImageSuccessState extends AppStates {}

class AppUploadPostImageErrorState extends AppStates {
  final String error;

  AppUploadPostImageErrorState(this.error);
}

class AppCreatePostLoadingState extends AppStates {}

class AppCreatePostSuccessState extends AppStates {}

class AppCreatePostErrorState extends AppStates {
  final String error;

  AppCreatePostErrorState(this.error);
}

class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsErrorState extends AppStates {
  final String error;

  AppGetPostsErrorState(this.error);
}

class AppLikePostLoadingState extends AppStates {}

class AppLikePostSuccessState extends AppStates {}

class AppDislikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {
  final String error;

  AppLikePostErrorState(this.error);
}

class AppCommentOnPostLoadingState extends AppStates {}

class AppCommentOnPostSuccessState extends AppStates {}

class AppCommentOnPostErrorState extends AppStates {
  final String error;

  AppCommentOnPostErrorState(this.error);
}

class AppGetPostCommentsLoadingState extends AppStates {}

class AppGetPostCommentsSuccessState extends AppStates {}

class AppGetPostCommentsErrorState extends AppStates {
  final String error;

  AppGetPostCommentsErrorState(this.error);
}

class AppGetUserPostsLoadingState extends AppStates {}

class AppGetUserPostsSuccessState extends AppStates {}

class AppGetUserPostsErrorState extends AppStates {
  final String error;

  AppGetUserPostsErrorState(this.error);
}

class AppGetUserIsLikedPostsLoadingState extends AppStates {}

class AppGetUserIsLikedPostsSuccessState extends AppStates {}

class AppGetUserIsLikedPostsErrorState extends AppStates {
  final String error;

  AppGetUserIsLikedPostsErrorState(this.error);
}

class AppGetPostLikesLoadingState extends AppStates {}

class AppGetPostLikesSuccessState extends AppStates {}

class AppGetPostLikesErrorState extends AppStates {
  final String error;

  AppGetPostLikesErrorState(this.error);
}

class AppSendCommentState extends AppStates {}

class AppPickTempImageLoadingState extends AppStates {}

class AppPickTempImageSuccessState extends AppStates {}

class AppPickTempImageErrorState extends AppStates {
  final String error;

  AppPickTempImageErrorState(this.error);
}

class AppUploadTempImageLoadingState extends AppStates {}

class AppUploadTempImageSuccessState extends AppStates {}

class AppUploadTempImageErrorState extends AppStates {
  final String error;

  AppUploadTempImageErrorState(this.error);
}

class AppSaveTempImageLinkLoadingState extends AppStates {}

class AppSaveTempImageLinkSuccessState extends AppStates {}

class AppSaveTempImageLinkErrorState extends AppStates {
  final String error;

  AppSaveTempImageLinkErrorState(this.error);
}

class AppGetUserImagesLoadingState extends AppStates {}

class AppGetUserImageSuccessState extends AppStates {}

class AppGetUserImagesErrorState extends AppStates {
  final String error;

  AppGetUserImagesErrorState(this.error);
}

class AppGeneralState extends AppStates {}
