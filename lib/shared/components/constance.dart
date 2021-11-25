
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import 'components.dart';

void signOut(context) {
  if(token == CacheHelper.getData(key: 'token'))
    CacheHelper.removeData(key:'token').then((value){
      token = CacheHelper.getData(key: 'token');
      print(token);
      if(value){
        navigateAndFinishTo(context, ShopLoginScreen());

      }
    });}




String? token;
String? uId;

