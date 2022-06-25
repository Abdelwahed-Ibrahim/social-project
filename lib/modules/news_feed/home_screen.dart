import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../post_screen/post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getAllPosts();
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return cubit.posts.isNotEmpty && cubit.userPostsIsLiked.isNotEmpty
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      homeHeader(),
                      Container(
                        color: Colors.grey[300],
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPost(
                            cubit.posts.values.elementAt(index),
                            context,
                            cubit,
                            cubit.posts.keys.elementAt(index),
                            showLikesScreen: () {},
                            showPostContent: () {
                              navigateTo(
                                context,
                                PostScreen(
                                  postId: cubit.posts.keys.elementAt(index),
                                ),
                              );
                            },
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 2.0,
                          ),
                          itemCount: cubit.posts.length,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  Widget homeHeader() => Stack(
        alignment: Alignment.centerRight,
        children: const [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5.0,
            child: SizedBox(
              height: 200.0,
              child: Image(
                width: double.infinity,
                fit: BoxFit.fill,
                image: NetworkImage(
                  'https://img.freepik.com/free-photo/impressed-surprised-man-points-away-blank-space_273609-40694.jpg',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Communicate With Friends',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
