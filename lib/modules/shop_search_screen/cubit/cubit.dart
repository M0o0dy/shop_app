import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search.dart';
import 'package:shop_app/modules/shop_search_screen/cubit/states.dart';
import 'package:shop_app/shared/components/constance.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';


class SearchCubit extends Cubit<SearchStates>{
  SearchCubit() : super(SearchInitialSate());
  static SearchCubit get(context)=> BlocProvider.of(context);


  late SearchProducts model;
  void search(String text,){
    emit(SearchLoadingSate());

    DioHelper.postData(url: SEARCH, data:{
      'text':text
    },
      token: token,
    ).then((value){

      model = SearchProducts.fromJson(value.data);

      emit(SearchSuccessSate());

    }).catchError((error){
      print('Error is ${error.toString()}');
      emit(SearchErrorSate());
    });
  }
}
