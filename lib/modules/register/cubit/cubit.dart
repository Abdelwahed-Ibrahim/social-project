import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import 'states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData icon = Icons.visibility;

  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      if (kDebugMode) {
        print(value.user!.email);
        print(value.user!.uid);
      }
      saveUserInformation(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
      emit(RegisterSuccessState(value.user!.uid));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(RegisterErrorState(error.toString()));
    });
  }

  void saveUserInformation({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    emit(CreateUserLoadingState());
    UserModel user = UserModel(
      uId: uId,
      name: name,
      nickName: '',
      bio: '',
      email: email,
      phone: phone,
      image:
          'https://pickaface.net/gallery/avatar/55315935_161016_0038_2nyrz79.png',
      coverImage:
          'https://img.freepik.com/free-photo/impressed-surprised-man-points-away-blank-space_273609-40694.jpg',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .set(user.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  void changeVisibility() {
    isPassword = !isPassword;
    icon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(RegisterChangePasswordVisibilityState());
  }
}
