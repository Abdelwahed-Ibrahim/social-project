import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/comment_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/styles.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({required this.postId, Key? key}) : super(key: key);
  final String postId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        List<CommentModel>? postComments = cubit.comments[postId];
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Post Details',
          ),
          body: cubit.posts[postId] != null
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildPost(
                        cubit.posts[postId]!,
                        context,
                        cubit,
                        postId,
                        showAllContent: true,
                      ),
                      if (postComments!.isNotEmpty)
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => mainDivider(),
                          itemBuilder: (context, index) =>
                              buildComment(postComments[index]),
                          itemCount: postComments.length,
                        ),
                      if (postComments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                              child: Text(
                            'No Comments yet!',
                            style: kStyleGreyBold18,
                          )),
                        )
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

  // var temp = Card(
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  // );

  Widget buildComment(CommentModel comment) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22.0,
                backgroundImage: NetworkImage(
                  '${comment.userImage}',
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            '${comment.userName}',
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
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.grey[300],
                      ),
                      child: Text(
                        comment.comment!,
                        style: kStyleBlackBold16,
                      ),
                    ),
                    Text(
                      '${comment.dateTime}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
