
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/login.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopChangeFavState extends ShopStates {}

class ShopSuccessChangeFavState extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavState(this.model);
}

class ShopErrorChangeFavState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateUserDataState extends ShopStates {}

class ShopSuccessUpdateUserDataState extends ShopStates {
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserDataState(this.loginModel);
}

class ShopErrorUpdateUserDataState extends ShopStates {}




