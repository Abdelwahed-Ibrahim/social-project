import 'package:flutter/material.dart';
import 'package:social_project/layout/cubit/cubit.dart';
import 'package:social_project/models/user_model.dart';

import '../../shared/styles/styles.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({required this.cubit, required this.postId, Key? key})
      : super(key: key);
  final AppCubit cubit;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      List<UserModel> postLikes = cubit.allPostsLikes[postId]!;
      return SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: postLikes.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Row(
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(
                            '${postLikes[index].image}',
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            '${postLikes[index].name}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                    itemCount: postLikes.length,
                  )
                : const Center(
                    child: Text(
                      'No Likes yet!',
                      style: kStyleGreyBold18,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
