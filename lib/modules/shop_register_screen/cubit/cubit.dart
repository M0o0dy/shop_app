


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login.dart';
import 'package:shop_app/modules/shop_register_screen/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {

  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context)=> BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }){
    emit(ShopRegisterLoadingState());
    DioHelper.postData(

        url: REGISTER,
        data: {
          'name':name,
          'phone':phone,
          'email':email,
          'password':password,
    }).then((value){
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((error){
      emit(ShopRegisterErrorState(error));
      print(error.toString());
    });
  }
  IconData suffixIcon = Icons.visibility;
  bool isPassword = true;
  void changeVisibility(){
    isPassword = !isPassword;

    suffixIcon = isPassword ? Icons.visibility :  Icons.visibility_off;
    emit(ShopRegisterVisibilityState());
  }


  bool isConfirmPassword = true;

  void changeConfirmVisibility(){
    isConfirmPassword = !isConfirmPassword;

    suffixIcon = isConfirmPassword ? Icons.visibility :  Icons.visibility_off;
    emit(ShopRegisterVisibilityState());
  }
}
