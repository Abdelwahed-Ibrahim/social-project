import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/cubit/cubit.dart';
import 'layout/layout_screen.dart';
import 'modules/login/login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/components.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';

void main() async {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CacheHelper.init();
      await Firebase.initializeApp();
      uId = CacheHelper.getData(key: 'uId');
      late Widget screen;
      if (uId == null) {
        screen = const LoginScreen();
      } else {
        screen = const Layout();
      }
      runApp(MyApp(screen));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.startWidget, {Key? key}) : super(key: key);
  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getUserInfo()
        ..getAllPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: startWidget,
        theme: myTheme(false),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
