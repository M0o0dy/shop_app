


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/shop_login_screen/cubit/cubit.dart';
import 'package:shop_app/modules/shop_login_screen/cubit/states.dart';
import 'package:shop_app/modules/shop_register_screen/shop_register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
          listener: (context, state) {
            if(state is ShopLoginSuccessState) {
              if(state.loginModel.status!)
              {
            print(state.loginModel.message);

            CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {
              token = state.loginModel.data!.token;
              ShopCubit.get(context).getUserData();
              ShopCubit.get(context).getHomeData();
              ShopCubit.get(context).getFavorites();



              navigateAndFinishTo(context, ShopLayout());
            }).catchError((error){print('Error is ${error.toString()}');});


              }else{

                print(state.loginModel.message);
                showToast(
                    msg: state.loginModel.message!,
                    state: ToastStates.ERROR
                );

              }
            }
          },
          builder: (context, state) {
            var cubit = ShopLoginCubit.get(context);
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Expanded(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'TawFir MaRket',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                    color: Colors.blueGrey[700],
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            Text(
                              'SIGN IN',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(

                                  children: [
                                    Text(
                                      'Or',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(color: Colors.black45),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        navigateTo(context, ShopRegisterScreen());
                                      },
                                      child: Text(
                                        'SIGN UP',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(color: Colors.blue,
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                                Text(
                                  ', To browse our hot Offers',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: Colors.black45),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            defaultFormField(
                              controller: emailController,
                              label: 'Email Address',
                              hintText : 'Enter your Email Address',
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
                              height: 15,
                            ),
                            defaultFormField(
                              controller: passwordController,
                              hintText : 'Enter your Password',
                              label: 'Password',
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
                          onSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                context:context,
                                  email: emailController.text,
                                  password: passwordController.text);


                            }
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Conditional.single(
                          widgetBuilder: (context) => defaultButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {

                                  cubit.userLogin(
                                      context:context,
                                      email: emailController.text,
                                      password: passwordController.text);


                                }
                              },
                                  label: 'SIGN IN'),
                              conditionBuilder:(context)=> state is! ShopLoginLoadingState,
                              fallbackBuilder: (context)=> Center(child: CircularProgressIndicator()),
                          context: context
                            ),
                            SizedBox(
                              height: 30,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
