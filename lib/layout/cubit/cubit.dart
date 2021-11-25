import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home.dart';
import 'package:shop_app/models/login.dart';
import 'package:shop_app/modules/shop_categories_screen/shop_categories_screen.dart';
import 'package:shop_app/modules/shop_favorite_screen/shop_favorite_screen.dart';
import 'package:shop_app/modules/shop_products_screen/shop_products-screen.dart';
import 'package:shop_app/modules/shop_settings_screen/shop_settings_screen.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(int index) {

    currentIndex = index;

    emit(ShopChangeBottomNavState());
  }

  List<Widget> bottomScreen = [
    ShopProductsScreen(),
    ShopCategoriesScreen(),
    ShopFavoriteScreen(),
    ShopSettingsScreen(),
  ];

   HomeModel? homeModel;
    Map<int, bool>? favorites = {};

  void getHomeData() {

    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {

      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data.products.forEach((element) {
        favorites?.addAll({element.id: element.inFavorites});
      });
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print('Error is ${error.toString()}');
      emit(ShopErrorHomeDataState());
    });
  }


   CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print('Error is ${error.toString()}');
      emit(ShopErrorCategoriesState());
    });
  }


  late ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId) {

     favorites![productId] = !favorites![productId]!;
    emit(ShopChangeFavState());
    DioHelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if(changeFavoritesModel.status) {
        getFavorites();
      }else{
        favorites![productId] = !favorites![productId]!;
        getFavorites();
      }

      emit(ShopSuccessChangeFavState(changeFavoritesModel));
    }).catchError((error) {
      favorites![productId] = !favorites![productId]!;
      emit(ShopErrorChangeFavState());
      print('error is ${error.toString()}');
    });
  }

    FavoritesModel? favoritesModel;

  void getFavorites() {

    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print('Error is ${error.toString()}');
      emit(ShopErrorGetFavoritesState());
    });
  }


  late ShopLoginModel loginModel;

  void getUserData() {

    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);

      print(loginModel.data!.token);
      emit(ShopSuccessUserDataState(loginModel));
    }).catchError((error) {
      print('Error is ${error.toString()}');
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
}) {

    emit(ShopLoadingUpdateUserDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token, data: {
      'name':name,
      'email':email,
      'phone':phone,
    },
    ).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);

      print(loginModel.data!.token);
      emit(ShopSuccessUpdateUserDataState(loginModel));
    }).catchError((error) {
      print('Error is ${error.toString()}');
      emit(ShopErrorUpdateUserDataState());
    });
  }


  }

