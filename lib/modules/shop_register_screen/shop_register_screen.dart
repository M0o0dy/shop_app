

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/shop_register_screen/cubit/cubit.dart';
import 'package:shop_app/modules/shop_register_screen/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopRegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, state) {
        if (state is ShopRegisterSuccessState) {
          if (state.loginModel.status!) {
            print(state.loginModel.message);
            print(state.loginModel.data!.token);
            CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {
              token = state.loginModel.data!.token;
              ShopCubit.get(context).getUserData();
              ShopCubit.get(context).getHomeData();
              ShopCubit.get(context).getFavorites();
              navigateAndFinishTo(context, ShopLayout());
            }).catchError((error) {
              print('Error is ${error.toString()}');
            });
          } else {
            print(state.loginModel.message);
            showToast(msg: state.loginModel.message!, state: ToastStates.ERROR);
          }
        }
      }, builder: (context, state) {
        ShopRegisterCubit cubit = ShopRegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To browse our hot Offers',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.black45),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: nameController,
                      label: 'User Name',
                      hintText: 'Enter your User Name',
                      prefixIcon: Icons.person,
                      keyboard: TextInputType.name,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'User Name can\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      label: 'Phone Number',
                      hintText: 'Enter your Phone Number',
                      prefixIcon: Icons.smartphone,
                      keyboard: TextInputType.phone,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Phone Number can\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: emailController,
                      label: 'Email Address',
                      hintText: 'Enter your Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Email Address can\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter your Password',
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: cubit.suffixIcon,
                      suffixPressed: () {
                        cubit.changeVisibility();
                      },
                      isPassword: cubit.isPassword,
                      keyboard: TextInputType.visiblePassword,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Enter your Password again',
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: cubit.suffixIcon,
                      suffixPressed: () {
                        cubit.changeConfirmVisibility();
                      },
                      isPassword: cubit.isConfirmPassword,
                      keyboard: TextInputType.visiblePassword,
                      validate: (String? value) {
                         if(value!.isEmpty){
                          return 'Please Confirm your Password';
                        }else
                        if (value != passwordController.text) {
                          return 'Your Password is wrong';

                        }
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Conditional.single(
                      context: context,
                      widgetBuilder: (context) => defaultButton(
                          onPressed: () {

                            if (formKey.currentState!.validate()) {
                              cubit.userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          label: 'SIGN UP'),
                      conditionBuilder:(context) => state is! ShopRegisterLoadingState,
                      fallbackBuilder: (context) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
