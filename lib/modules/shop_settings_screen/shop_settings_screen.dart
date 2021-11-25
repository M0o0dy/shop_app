import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopSettingsScreen extends StatelessWidget {
  var tokenController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context).loginModel.data!;

        nameController.text = cubit.name!;
        phoneController.text = cubit.phone!;
        emailController.text = cubit.email!;
        return Conditional.single(
          context: context,
          conditionBuilder:(context) =>  cubit.toString().isNotEmpty? true :false,
          widgetBuilder: (context) => SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Expanded(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if(state is ShopLoadingUpdateUserDataState)

                        LinearProgressIndicator(
                          color: Colors.orange,
                          backgroundColor: Colors.orangeAccent[100],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          outLineColor: Colors.orangeAccent,
                          controller: nameController,
                          label: 'Name',
                          prefixIcon: Icons.person,
                          keyboard: TextInputType.name,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          outLineColor: Colors.orangeAccent,
                          controller: emailController,
                          label: 'Email Address',
                          prefixIcon: Icons.email,
                          keyboard: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          outLineColor: Colors.orangeAccent,
                          controller: phoneController,
                          label: 'Phone Number',
                          prefixIcon: Icons.smartphone,
                          keyboard: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: defaultButton(
                                    label: 'Update',
                                    color: Colors.orangeAccent,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        ShopCubit.get(context).updateUserData(
                                          name: nameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text,
                                        );
                                        if(state is ShopSuccessUpdateUserDataState) {

                                          showToast(
                                              msg: state.loginModel.message!,
                                              state: ToastStates.SUCCESS);
                                        }else
                                          showToast(
                                              msg: 'Try again',
                                              state: ToastStates.SUCCESS);
                                      }
                                    }),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: defaultButton(
                                    label: 'Sign Out',
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      // signOut(context);
                                      CacheHelper.removeData(key:'onBoarding');
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
