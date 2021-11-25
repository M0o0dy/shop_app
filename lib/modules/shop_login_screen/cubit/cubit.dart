

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/models/login.dart';
import 'package:shop_app/modules/shop_login_screen/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {

  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context)=> BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userLogin({

    required context,
    required String email,
    required String password,


  }){

    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: LOGIN,
        data: {'email':email,
          'password':password,
    }).then((value){

      loginModel = ShopLoginModel.fromJson(value.data);
      ShopCubit.get(context).currentIndex = 0;
      emit(ShopLoginSuccessState(loginModel));
      print(loginModel.data!.name);
      print(loginModel.data!.token);


    }).catchError((error){
      emit(ShopLoginErrorState(error.toString()));
      print('error is ${error.toString()}');
    });
  }
  IconData suffixIcon = Icons.visibility;
  bool isPassword = true;
  void changeVisibility(){
    isPassword = !isPassword;

    suffixIcon = isPassword ? Icons.visibility :  Icons.visibility_off;
    emit(ShopLoginVisibilityState());
  }

}
