

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories.dart';
import 'package:shop_app/shared/components/components.dart';

class ShopCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context).categoriesModel!.data.data;
        return ListView.separated(

          physics: BouncingScrollPhysics(),

          itemBuilder: (context,index)=>catItemBuilder(cubit[index]),
          separatorBuilder: (context,index)=> myDivider(),
          itemCount: cubit.length ,
        );
      },
    );
  }

  Widget catItemBuilder(DataModel model) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20,),
            Container(
              width: 103,
              child: Text(
               model.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 35,
            ),
          ],
        ),
      );
}
