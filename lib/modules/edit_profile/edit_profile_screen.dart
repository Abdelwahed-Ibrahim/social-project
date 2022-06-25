import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/icon_broken.dart';
import '../../shared/styles/styles.dart';

var nameController = TextEditingController();
var nicknameController = TextEditingController();
var phoneController = TextEditingController();
var bioController = TextEditingController();

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    nameController.text = AppCubit.get(context).user.name!;
    nicknameController.text = AppCubit.get(context).user.nickName!;
    phoneController.text = AppCubit.get(context).user.phone!;
    bioController.text = AppCubit.get(context).user.bio!;
    AppCubit.get(context).allowEditName =
        AppCubit.get(context).allowEditNickname = AppCubit.get(context)
            .allowEditBio = AppCubit.get(context).allowEditPhone = false;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        var profileImage = cubit.profileImage;

        var coverImage = cubit.coverImage;

        UserModel userModel = cubit.user;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    cubit.updateUser(
                      name: nameController.text,
                      nickName: nicknameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileImageSection(profileImage, cubit, userModel),
                  coverImageSection(coverImage, cubit, userModel),
                  editNameSection(context, cubit, userModel),
                  editNicknameSection(context, cubit, userModel),
                  editBioSection(context, cubit, userModel),
                  editPhoneSection(context, cubit, userModel),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget profileImageSection(
          File? profileImage, AppCubit cubit, UserModel userModel) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Profile image',
                  style: kStyleBlackBold18,
                ),
                const Spacer(),
                if (cubit.profileImage != null)
                  InkWell(
                    onTap: cubit.uploadProfileImage,
                    child: Text(
                      'Upload',
                      style: kStyleBlack18.copyWith(color: defaultColor),
                    ),
                  ),
              ],
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 64.0,
                  backgroundColor: defaultColor,
                  child: (profileImage == null)
                      ? CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage('${userModel.image}'),
                        )
                      : CircleAvatar(
                          radius: 60.0,
                          backgroundImage: FileImage(profileImage),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey[300],
                    child: InkWell(
                      onTap: cubit.pickProfileImage,
                      child: const Icon(
                        IconBroken.Camera,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          mainDivider(),
        ],
      );

  Widget coverImageSection(
          File? coverImage, AppCubit cubit, UserModel userModel) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Cover photo',
                  style: kStyleBlackBold18,
                ),
                const Spacer(),
                if (cubit.coverImage != null)
                  InkWell(
                    onTap: cubit.uploadCoverImage,
                    child: Text(
                      'Upload',
                      style: kStyleBlack18.copyWith(color: defaultColor),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: (coverImage == null)
                      ? Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            '${userModel.coverImage}',
                          ),
                        )
                      : Image(
                          fit: BoxFit.fill,
                          image: FileImage(coverImage),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey[300],
                    child: InkWell(
                      onTap: cubit.pickCoverImage,
                      child: const Icon(
                        IconBroken.Camera,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          mainDivider(),
        ],
      );

  Widget editNameSection(
          BuildContext context, AppCubit cubit, UserModel userModel) =>
      Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Name',
                  style: kStyleBlackBold18,
                ),
                const Spacer(),
                if (!cubit.allowEditName)
                  InkWell(
                    onTap: cubit.allowEditingName,
                    child: Icon(
                      IconBroken.Edit_Square,
                      color: defaultColor,
                    ),
                  ),
              ],
            ),
          ),
          cubit.allowEditName
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: defaultTextFieldWithoutBorder(
                        controller: nameController,
                        hintText: 'Name',
                        autoFocus: true,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        cubit.allowEditingName();
                        cubit.updateUserInfo(
                          name: nameController.text,
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    '${userModel.name}',
                    style: kStyleGreyBold18,
                  ),
                ),
          const SizedBox(
            height: 20.0,
          ),
          mainDivider(),
        ],
      );

  Widget editNicknameSection(
          BuildContext context, AppCubit cubit, UserModel userModel) =>
      Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Nickname',
                  style: kStyleBlackBold18,
                ),
                const Spacer(),
                if (!cubit.allowEditNickname)
                  InkWell(
                    onTap: cubit.allowEditingNickname,
                    child: Icon(
                      IconBroken.Edit_Square,
                      color: defaultColor,
                    ),
                  ),
              ],
            ),
          ),
          cubit.allowEditNickname
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: defaultTextFieldWithoutBorder(
                        controller: nicknameController,
                        hintText: 'Nickname',
                        autoFocus: true,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        cubit.allowEditingNickname();
                        cubit.updateUserInfo(
                          nickName: nicknameController.text,
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    '(${userModel.nickName})',
                    style: kStyleGreyBold18,
                  ),
                ),
          const SizedBox(
            height: 20.0,
          ),
          mainDivider(),
        ],
      );

  Widget editBioSection(
          BuildContext context, AppCubit cubit, UserModel userModel) =>
      Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Bio',
                  style: kStyleBlackBold18,
                ),
                const Spacer(),
                if (!cubit.allowEditBio)
                  InkWell(
                    onTap: cubit.allowEditingBio,
                    child: Icon(
                      IconBroken.Edit_Square,
                      color: defaultColor,
                    ),
                  ),
              ],
            ),
          ),
          cubit.allowEditBio
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: defaultTextFieldWithoutBorder(
                          controller: bioController,
                          hintText: 'Bio',
                          autoFocus: true,
                          keyboardType: TextInputType.text,
                        )),
                    TextButton(
                      onPressed: () {
                        cubit.allowEditingBio();
                        cubit.updateUserInfo(
                          bio: bioController.text,
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    '${userModel.bio}',
                    style: kStyleGreyBold18,
                  ),
                ),
          const SizedBox(
            height: 20.0,
          ),
          mainDivider(),
        ],
      );

  Widget editPhoneSection(
          BuildContext context, AppCubit cubit, UserModel userModel) =>
      Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Phone',
                  style: kStyleBlackBold18,
                ),
                const Spacer(),
                if (!cubit.allowEditPhone)
                  InkWell(
                    onTap: cubit.allowEditingPhone,
                    child: Icon(
                      IconBroken.Edit_Square,
                      color: defaultColor,
                    ),
                  ),
              ],
            ),
          ),
          cubit.allowEditPhone
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: defaultTextFieldWithoutBorder(
                        controller: phoneController,
                        hintText: 'Phone',
                        autoFocus: true,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        cubit.allowEditingPhone();
                        cubit.updateUserInfo(
                          phone: phoneController.text,
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    '${userModel.phone}',
                    style: kStyleGreyBold18,
                  ),
                ),
          const SizedBox(
            height: 20.0,
          ),
          mainDivider(),
        ],
      );
}
