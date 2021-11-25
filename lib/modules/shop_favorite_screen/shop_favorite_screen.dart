
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ShopFavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context).favoritesModel!.data!.data;
        return Conditional.single(
          conditionBuilder: (BuildContext context) =>
              state is! ShopLoadingGetFavoritesState,
          widgetBuilder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                favItemBuilder(cubit![index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: cubit!.length,
          ),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
          context: context,
        );
      },
    );
  }

  Widget favItemBuilder(FavoritesModelData model, context) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            height: 120,
            width: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        image: NetworkImage(
                          model.product!.image!,
                        ),
                        width: 120,
                        height: 120,
                      ),
                      if (model.product!.discount != 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.red,
                          child: Text(
                            'DISCOUNT',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          model.product!.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.3,
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${model.product!.price.round()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: defaultColor),
                            ),
                          ),
                          SizedBox(width: 5,),

                          if (model.product!.discount != 0)
                            Expanded(
                              child: Text(
                                '${model.product!.oldPrice.round()}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black45,
                                    decoration:
                                        TextDecoration.lineThrough),
                              ),
                            ),

                           Spacer(),
                         Expanded(
                           flex: 2,
                           child: Row(
                             children: [
                               Expanded(
                                 child: IconButton(
                                   onPressed: () {
                                     ShopCubit.get(context)
                                         .changeFavorites(model.product!.id!);
                                   },
                                   icon: ShopCubit.get(context)
                                       .favorites![model.product!.id]!
                                       ? Icon(
                                     Icons.favorite,
                                     color: Colors.red,
                                   )
                                       : Icon(Icons.favorite_border,
                                       color: defaultColor),
                                 ),
                               ),
                               SizedBox(width: 10,),
                               Expanded(
                                 child: IconButton(
                                   onPressed: () {},
                                   icon: Icon(
                                     Icons.add_shopping_cart,
                                     size: 25,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
