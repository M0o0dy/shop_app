import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories.dart';
import 'package:shop_app/models/home.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ShopProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavState){
          if(state.model.status){
            showToast(msg: state.model.message, state:ToastStates.ERROR );
          }
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => cubit.homeModel != null && cubit.categoriesModel != null,
          widgetBuilder: (context) => productsBuilder(cubit.homeModel!,cubit.categoriesModel!,context),
          fallbackBuilder: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel model,CategoriesModel categoriesModel,context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CarouselSlider(
              items: model.data.banners
                  .map((e) => Image(
                        image: NetworkImage('${e.image}'),
                        width: double.infinity,
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 250,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                scrollDirection: Axis.horizontal,
                viewportFraction: 1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index)=>categoriesBuilder(categoriesModel.data.data[index],),
                      separatorBuilder: (context,index)=> SizedBox(width: 10,),
                      itemCount: categoriesModel.data.data.length,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              child: GridView.count(
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.58,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(model.data.products.length,
                    (index) => gridBuilder(model.data.products[index],context)),
              ),
            ),
          ],
        ),
      );

  Widget gridBuilder(ProductModel model,context) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(
                      model.image,
                    ),
                    width: double.infinity,
                    height: 200,
                  ),
                  if (model.discount != 0)
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.3,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${model.price.round()}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize : 17 ,color: defaultColor),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        if (model.discount != 0)
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${model.oldPrice.round()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                  color: Colors.black45,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id);
                            },
                            icon: ShopCubit.get(context).favorites![model.id]! ?
                            Icon(Icons.favorite,color: Colors.red, ) : Icon(Icons.favorite_border,color: defaultColor),

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
  );

  Widget categoriesBuilder(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100,
            color: Colors.black.withOpacity(0.7),
            child: Text(
              model.name,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}
