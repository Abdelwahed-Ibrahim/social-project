import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../modules/new_post/new_post_screen.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/styles/icon_broken.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {
        if (state is AppSendEmailVerificationSuccessState) {
          if (kDebugMode) {
            print(FirebaseAuth.instance.currentUser!.emailVerified);
          }
          showToast(
            message: 'Check your Mail',
            state: ToastStates.SUCCESS,
          );
        }
      },
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 3.0,
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                splashRadius: 15.0,
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Search,
                ),
              ),
              IconButton(
                splashRadius: 15.0,
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Notification,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (!FirebaseAuth.instance.currentUser!.emailVerified)
                verificationWidget(cubit.verifyEmail),
              Expanded(child: cubit.screens[cubit.currentIndex]),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: defaultColor,
            onPressed: () {
              navigateTo(context, const NewPostScreen());
            },
            child: const Icon(IconBroken.Edit),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 5.0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.User),
                label: 'Nearby',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: 'Settings',
              ),
            ],
            currentIndex: cubit.currentIndex,
            onTap: cubit.changeNavIndex,
          ),
        );
      },
    );
  }

  Widget verificationWidget(Function() function) => Container(
        color: Colors.amber.withOpacity(0.6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
              ),
              const SizedBox(
                width: 15.0,
              ),
              const Text(
                'Please Verify your E-Mail',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const Spacer(),
              defaultTextButton(
                onPressed: function,
                text: 'Verify',
              ),
            ],
          ),
        ),
      );
}
