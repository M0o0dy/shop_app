import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/shop_search_screen/shop_search_screen.dart';
import 'package:shop_app/shared/components/components.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'TawFir MaRket',
              style: TextStyle(
                color: Colors.blueGrey[700],
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {

                    navigateTo(context, ShopSearchScreen());
                  },
                  icon: Icon(Icons.search,size: 35,),



              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(

            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps,),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite,),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings,),
                label: 'Settings',
              ),
            ],
            currentIndex: cubit.currentIndex,
            showSelectedLabels: true,
            onTap: (index){cubit.changeIndex(index);},
          ),
          body: cubit.bottomScreen[cubit.currentIndex],
        );
      },
    );
  }
}
