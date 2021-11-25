
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'layout/cubit/cubit.dart';
import 'layout/shop_layout.dart';
import 'modules/on_boarding_screen/on_boarding_screen.dart';
import 'modules/shop_login_screen/shop_login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  if(onBoarding != null){
    if(token != null){
      widget =  ShopLayout();
    }else widget = ShopLoginScreen();
  }else widget = OnBoardingScreen();
  runApp(MyApp(
      startWidget: widget
  ));
}
class MyApp extends StatelessWidget
{

  Widget? startWidget;
  MyApp({this.startWidget});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getUserData()..getHomeData()..getCategories()..getFavorites(),
      child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context,state){},
          builder: (context,state) {

            return MaterialApp(

              theme:lightTheme,
              darkTheme:  darkTheme,
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              home: startWidget,
            );
          }
      ),
    );
  }

}
