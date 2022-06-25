import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/icon_broken.dart';
import '../../shared/styles/styles.dart';

var postController = TextEditingController();

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    postController.text = '';
    AppCubit.get(context).postImage = null;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            elevation: null,
            title: 'Add Post',
            actions: [
              Container(
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    if (cubit.postImage == null) {
                      cubit.createPost(
                        dateTime: DateFormat('MMMM d, yyyy At h:mm a')
                            .format(DateTime.now())
                            .toString(),
                        postText: postController.text,
                      );
                    } else {
                      cubit.uploadPostWithImage(
                        dateTime: DateFormat('MMMM d, yyyy At h:mm a')
                            .format(DateTime.now())
                            .toString(),
                        postText: postController.text,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Post'),
                ),
              )
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26.0,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            '${cubit.user.image}',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${cubit.user.name}',
                        style: kStyleBlackBold18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                // defaultTextField(
                //   minLines: 8,
                //   maxLines: 8,
                //   alignCenter: false,
                //   hintText: 'What\'s on your mind?',
                //   controller: postController,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    maxLines: 8,
                    style: kStyleBlackBold16,
                    controller: postController,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind?',
                      hintStyle: kStyleBlack16.copyWith(
                        color: defaultColor.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (cubit.postImage != null)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14.0),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image(
                                fit: BoxFit.fill,
                                image: FileImage(cubit.postImage!),
                              ),
                            ),
                            CircleAvatar(
                              radius: 14.0,
                              backgroundColor: defaultColor.withOpacity(.3),
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
                      ),
                    ),
                  ),
                if (cubit.postImage == null)
                  const Expanded(
                      child: SizedBox(
                    width: double.infinity,
                  )),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: cubit.pickPostImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(IconBroken.Image),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Add Tag'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
