import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_project/modules/likes_screen/likes_screen.dart';
import 'package:social_project/shared/styles/styles.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/post_model.dart';
import '../styles/icon_broken.dart';
import 'constants.dart';

ThemeData myTheme(bool isDark) => ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: isDark ? const Color(0xff333739) : Colors.white,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        titleSpacing: 20.0,
        color: isDark ? const Color(0xff333739) : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: isDark ? const Color(0xff333739) : Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 20.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? const Color(0xff333734) : Colors.white,
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey,
      ),
    );

void navigateTo(BuildContext context, Widget myNavigation) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => myNavigation,
      ),
    );

void navigateAndFinish(BuildContext context, Widget myNavigation) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => myNavigation,
      ),
      (route) => false,
    );

Widget defaultTextButton({
  required Function() onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );

AppBar defaultAppBar({
  required BuildContext context,
  List<Widget>? actions,
  String? title,
  var elevation = 3.0,
}) =>
    AppBar(
      elevation: elevation,
      leading: IconButton(
        splashRadius: 15.0,
        icon: const Icon(IconBroken.Arrow___Left_2),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: title != null ? Text(title) : null,
      actions: actions,
      titleSpacing: 0.0,
      // centerTitle: true,
    );

Widget defaultTextField({
  required TextEditingController controller,
  required String hintText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  void Function()? onSuffixPressed,
  void Function(String)? onSubmit,
  bool isPassword = false,
  bool autoFocus = false,
  bool alignCenter = true,
  int minLines = 1,
  int maxLines = 1,
}) =>
    TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPassword,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: defaultColor.withOpacity(.5)),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(3.0)),
          borderSide: BorderSide(color: defaultColor.withOpacity(.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: defaultColor),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: defaultColor,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixPressed,
                icon: Icon(
                  suffixIcon,
                  color: defaultColor,
                ),
              )
            : null,
      ),
      textAlign: alignCenter ? TextAlign.center : TextAlign.start,
      validator: validator,
      onFieldSubmitted: onSubmit,
    );

Widget defaultTextFieldWithoutBorder({
  required TextEditingController controller,
  required String hintText,
  IconData? prefixIcon,
  IconData? suffixIcon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  void Function()? onSuffixPressed,
  void Function(String)? onSubmit,
  bool isPassword = false,
  bool autoFocus = false,
}) =>
    TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPassword,
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: defaultColor),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: defaultColor,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixPressed,
                icon: Icon(
                  suffixIcon,
                  color: defaultColor,
                ),
              )
            : null,
      ),
      textAlign: TextAlign.center,
      validator: validator,
      onFieldSubmitted: onSubmit,
      style: kStyleBlackBold18,
    );

Widget defaultButton({
  required void Function() onPressed,
  required String defaultText,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      child: MaterialButton(
        child: Text(
          defaultText.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
        color: defaultColor,
        height: 40.0,
      ),
    );

void showToast({required String message, required ToastStates state}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 18.0,
    );

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget searchTextFormField({
  required TextEditingController controller,
  required IconData prefixIcon,
  required String hint,
  required BuildContext context,
  bool isAutoFocus = false,
  bool isReadOnly = false,
  String? Function(String?)? validation,
  Function()? onTouch,
  Function(String)? onChange,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: TextFormField(
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.normal),
        cursorColor: Colors.black,
        controller: controller,
        textAlign: TextAlign.center,
        readOnly: isReadOnly,
        autofocus: isAutoFocus,
        validator: validation,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        onTap: onTouch,
        onChanged: onChange,
      ),
    );

Widget mainDivider() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        height: 0.8,
      ),
    );

Widget buildPost(
  PostModel post,
  BuildContext context,
  AppCubit cubit,
  String postId, {
  bool showAllContent = false,
  void Function()? showLikesScreen,
  void Function()? showPostContent,
}) =>
    Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          postHeader(post),
          postContent(
            post,
            showAllContent: showAllContent,
            showPostContent: showPostContent,
          ),
          // Post Image
          if (post.postImage != '')
            postImage(
              post,
              showPostContent: showPostContent,
              showAllContent: showAllContent,
            ),
          postCommentAndLikes(
            post,
            cubit,
            context,
            postId,
            showLikesScreen: showLikesScreen,
            onPressCommentIcon: showPostContent,
          ),
          postDivider(),
          postFooter(context, cubit, postId),
        ],
      ),
    );

Widget postContent(
  PostModel post, {
  bool showAllContent = false,
  void Function()? showPostContent,
}) =>
    Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: InkWell(
        onTap: () {
          if (!showAllContent) {
            showPostContent!();
          }
        },
        child: showAllContent
            ? Text(
                '${post.postText}',
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              )
            : Text(
                '${post.postText}',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
      ),
    );

Widget postTags(PostModel post) => SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
        child: Wrap(
          children: [
            hashTag('SoftwareDevelopment'),
            hashTag('Software'),
            hashTag('Development'),
            hashTag('MobileDevelopment'),
            hashTag('FlutterDevelopment'),
            hashTag('AppDevelopment'),
            hashTag('Flutter'),
          ],
        ),
      ),
    );

Widget postImage(
  PostModel post, {
  bool showAllContent = false,
  void Function()? showPostContent,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (showPostContent != null && !showAllContent) {
            showPostContent();
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image(
            image: NetworkImage(
              '${post.postImage}',
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

Widget postCommentAndLikes(
  PostModel post,
  AppCubit cubit,
  BuildContext context,
  String postId, {
  void Function()? showLikesScreen,
  void Function()? onPressCommentIcon,
}) =>
    SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50.0),
                ),
                // foregroundDecoration: BoxDecoration(
                //   border: Border.fromBorderSide(
                //     BorderSide(
                //       color: defaultColor,
                //     ),
                //   ),
                //   borderRadius: BorderRadius.circular(50.0),
                // ),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => LikesScreen(
                        cubit: cubit,
                        postId: postId,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconBroken.Heart,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      cubit.postsLikes[postId] != null
                          ? Text('${cubit.postsLikes[postId]}')
                          : const Text('0'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.grey[200],
                ),
                // foregroundDecoration: BoxDecoration(
                //   border: Border.fromBorderSide(
                //     BorderSide(
                //       color: defaultColor,
                //     ),
                //   ),
                //   borderRadius: BorderRadius.circular(50.0),
                // ),
                child: InkWell(
                  onTap: onPressCommentIcon,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconBroken.Chat,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      cubit.postsComments[postId] != null
                          ? Text('${cubit.postsComments[postId]}')
                          : const Text('0'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget postDivider() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        height: 0.8,
      ),
    );

Widget postHeader(PostModel post) => Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.0,
            backgroundImage: NetworkImage(
              '${post.userImage}',
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  Text(
                    '${post.userName}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.check_circle_sharp,
                    size: 12.0,
                    color: defaultColor,
                  ),
                ],
              ),
              Text(
                '${post.dateTime}',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            splashRadius: 15.0,
            constraints: const BoxConstraints(
              maxWidth: 30.0,
              maxHeight: 30.0,
            ),
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.black38,
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          IconButton(
            splashRadius: 15.0,
            constraints: const BoxConstraints(
              maxWidth: 30.0,
              maxHeight: 30.0,
            ),
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.close,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );

var tempProfileImage =
    'https://pickaface.net/gallery/avatar/55315935_161016_0038_2nyrz79.png';

// TODO: Modify the Comment TextField

Widget postFooter(BuildContext context, AppCubit cubit, String postId) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                cubit.user.image != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(cubit.user.image!),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(tempProfileImage),
                      ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      var commentController = TextEditingController();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => writeCommentField(
                          context,
                          commentController,
                          cubit,
                          postId,
                        ),
                      );
                    },
                    child: Container(
                      height: 35.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Colors.grey[100],
                      ),
                      child: const Center(
                        child: Text(
                          'Write a comment ...',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: cubit.userPostsIsLiked[postId]!
                    ? defaultColor.withOpacity(0.3)
                    : Colors.white,
              ),
              child: InkWell(
                onTap: () {
                  cubit.likePost(postId);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconBroken.Heart,
                      color: defaultColor,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Like',
                      style: TextStyle(
                        color: defaultColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

Widget hashTag(String tag) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
      child: InkWell(
        onTap: () {},
        child: Text(
          '#$tag',
          style: TextStyle(
            color: defaultColor,
            fontSize: 14.0,
          ),
        ),
      ),
    );

Widget writeCommentField(
        BuildContext context,
        TextEditingController commentController,
        AppCubit cubit,
        String postId) =>
    BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    contentPadding: const EdgeInsets.all(8.0),
                    hintText: 'Write a public comment...',
                    suffixIcon: cubit.allowSendComment
                        ? IconButton(
                            icon: Icon(
                              Icons.send,
                              color: defaultColor,
                            ),
                            onPressed: () {
                              if (commentController.text != '') {
                                cubit.postComment(
                                  postId,
                                  commentController.text,
                                );
                                cubit.allowSendComment = false;
                                Navigator.pop(context);
                              }
                            })
                        : null,
                  ),
                  onChanged: cubit.allowSendingComment,
                  controller: commentController,
                  autofocus: true,
                ),
              ),
            ),
          ),
        );
      },
    );
