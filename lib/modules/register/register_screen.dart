import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/layout_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../login/login_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

var nameController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();
var passwordController = TextEditingController();
var formKey = GlobalKey<FormState>();

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
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
          // if (state is ShopRegisterSuccessState) {
          //   if (state.loginModel.status!) {
          //     showToast(
          //       message: state.loginModel.message!,
          //       state: ToastStates.SUCCESS,
          //     );
          //     if (kDebugMode) {
          //       print(state.loginModel.message);
          //       print(state.loginModel.data!.token);
          //     }
          //     CacheHelper.setData(
          //       key: 'token',
          //       value: state.loginModel.data!.token,
          //     ).then((value) {
          //       token = state.loginModel.data!.token;
          //       navigateAndFinish(
          //         context,
          //         const ShopLayoutScreen(),
          //       );
          //     });
          //   } else {
          //     showToast(
          //       message: state.loginModel.message!,
          //       state: ToastStates.ERROR,
          //     );
          //     if (kDebugMode) {
          //       print(state.loginModel.message);
          //     }
          //   }
          // }
          // if (state is ShopRegisterErrorState) {
          //   showToast(
          //     message: state.error,
          //     state: ToastStates.ERROR,
          //   );
          // }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
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
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: defaultColor,
                                    fontSize: 34.0,
                                  ),
                        ),
                        Text(
                          'Register Now To Communicate With Your Friends',
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
                          controller: nameController,
                          hintText: 'Name',
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            }
                            return null;
                          },
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
                          controller: phoneController,
                          hintText: 'Phone',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
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
                              cubit.userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        (state is! RegisterLoadingState)
                            ? defaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                defaultText: 'register',
                              )
                            : const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'already have an account!',
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
                                  const LoginScreen(),
                                );
                              },
                              text: 'login',
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
