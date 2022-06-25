import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/icon_broken.dart';
import '../../shared/styles/styles.dart';
import '../edit_profile/edit_profile_screen.dart';
import '../post_screen/post_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // AppCubit cubit = AppCubit.get(context);
        // cubit.widget ??= userPosts(cubit);
        // if (state is! AppGeneralState) {
        //   cubit.widget = userPosts(cubit);
        // }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        UserModel userModel = cubit.user;
        if (cubit.userPosts.isEmpty) {
          cubit.getAllUserPosts();
        }
        return cubit.userPosts.isNotEmpty
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 150.0,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    '${userModel.coverImage}',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 64.0),
                            ],
                          ),
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                '${userModel.image}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${userModel.name}',
                            style: kStyleBlackBold20,
                          ),
                          Icon(
                            Icons.check_circle_sharp,
                            size: 14.0,
                            color: defaultColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${userModel.nickName})',
                        style: kStyleBlackBold20,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${userModel.bio}',
                        style: kStyleGrey18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  cubit.widget = userPosts(cubit);
                                  cubit.setState();
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${cubit.userPosts.length}',
                                        style: kStyleBlackBold16,
                                      ),
                                      const Text(
                                        'Posts',
                                        style: kStyleGreyBold14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  cubit.widget = userImages(cubit);
                                  cubit.setState();
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${cubit.images.length}',
                                        style: kStyleBlackBold16,
                                      ),
                                      const Text(
                                        'Photos',
                                        style: kStyleGreyBold14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        '10k',
                                        style: kStyleBlackBold16,
                                      ),
                                      Text(
                                        'Followers',
                                        style: kStyleGreyBold14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        '64',
                                        style: kStyleBlackBold16,
                                      ),
                                      Text(
                                        'Following',
                                        style: kStyleGreyBold14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                cubit.pickTempImage();
                              },
                              child: const Text('Add Photo'),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              cubit.coverImage = null;
                              cubit.profileImage = null;
                              navigateTo(context, const EditProfileScreen());
                            },
                            child: const Icon(
                              IconBroken.Setting,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                      if (cubit.tempImage != null)
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14.0),
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image(
                                        fit: BoxFit.fill,
                                        image: FileImage(cubit.tempImage!),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor:
                                          defaultColor.withOpacity(.3),
                                      child: InkWell(
                                        onTap: cubit.removePickedImage,
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: defaultColor.withOpacity(.3),
                                  child: InkWell(
                                    onTap: cubit.uploadTempImage,
                                    child: const Icon(
                                      Icons.cloud_upload,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      cubit.widget ??= userPosts(cubit),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget userPosts(AppCubit cubit) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => buildPost(
              cubit.userPosts.values.elementAt(index),
              context,
              cubit,
              cubit.userPosts.keys.elementAt(index),
              showLikesScreen: () {},
              showPostContent: () {
                navigateTo(
                  context,
                  PostScreen(
                    postId: cubit.userPosts.keys.elementAt(index),
                  ),
                );
              },
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 2.0,
            ),
            itemCount: cubit.userPosts.length,
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      );

  Widget userImages(AppCubit cubit) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(cubit.images[index]),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                itemCount: cubit.images.length)
          ],
        ),
      );
}
