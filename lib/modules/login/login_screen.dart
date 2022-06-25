import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/layout_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
var formKey = GlobalKey<FormState>();

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.setData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              uId = state.uId;
              navigateAndFinish(
                context,
                const Layout(),
              );
            });
          }
          // if (state is ShopLoginSuccessState) {
          //   if (state.loginModel.status!) {
          //     showToast(
          //       message: state.loginModel.message!,
          //       state: ToastStates.SUCCESS,
          //     );
          //     if (kDebugMode) {
          //       print(state.loginModel.message);
          //       print(state.loginModel.data!.token);
          //     }

          //   } else {-
          //     showToast(
          //       message: state.loginModel.message!,
          //       state: ToastStates.ERROR,
          //     );
          //     if (kDebugMode) {
          //       print(state.loginModel.message);
          //     }
          //   }
          // }
          // if (state is ShopLoginErrorState) {
          //   showToast(
          //     message: state.error,
          //     state: ToastStates.ERROR,
          //   );
          // }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: defaultColor,
                                    fontSize: 34.0,
                                  ),
                        ),
                        Text(
                          'Login Now To Communicate With Your Friends',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 20.0,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextField(
                          controller: emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          isPassword: cubit.isPassword,
                          prefixIcon: Icons.lock_outline,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          suffixIcon: cubit.icon,
                          onSuffixPressed: cubit.changeVisibility,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        (state is! LoginLoadingState)
                            ? defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                defaultText: 'login',
                              )
                            : const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'don\'t have an account yet?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 20.0,
                                  ),
                            ),
                            defaultTextButton(
                              onPressed: () {
                                navigateAndFinish(
                                  context,
                                  const RegisterScreen(),
                                );
                              },
                              text: 'register',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
