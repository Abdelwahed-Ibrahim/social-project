import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData icon = Icons.visibility;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (kDebugMode) {
        print(value.user!.email);
        print(value.user!.uid);
      }
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(LoginErrorState(error.toString()));
    });
  }

  void changeVisibility() {
    isPassword = !isPassword;
    icon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(LoginChangePasswordVisibilityState());
  }
}
