import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/models/search.dart';
import 'package:shop_app/modules/shop_search_screen/cubit/cubit.dart';
import 'package:shop_app/modules/shop_search_screen/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';


class ShopSearchScreen extends StatefulWidget {
  @override
  _ShopSearchScreenState createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {
  bool isOldPrice = false;

  var searchController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          ShopCubit.get(context).getUserData();
          ShopCubit.get(context).getHomeData();
          ShopCubit.get(context).getFavorites();


        },
        builder: (context, state) {
          var cubit = SearchCubit.get(context);

          return
                Scaffold(
                  appBar: AppBar(),
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          defaultFormField(
                              controller: searchController,
                              label: 'Search',
                              validate: (String? value){
                                setState(() {});
                                if(value!.isEmpty) {
                                  return 'Type to search';
                                }return null;
                              },
                              prefixIcon: Icons.search,
                              keyboard: TextInputType.text,
                              hintText: 'What do you want Search for ?',
                              onChanged: (String value){
                                if(formKey.currentState!.validate())
                                  cubit.search(value);
                                return null;
                              },

                          ),
                          SizedBox(height: 10,),
                          if(state is SearchLoadingSate)
                          LinearProgressIndicator(
                            color: defaultColor,
                            backgroundColor: Colors.blue[100],
                          ),
                          if(state is SearchSuccessSate)

                            Expanded(
                            child:  ListView.separated(

                              physics: BouncingScrollPhysics(),

                              itemBuilder: (context, index) => searchController.text.isNotEmpty ?
                                   searchItemBuilder(cubit.model.data!.data![index], context): Container(color: Colors.white,),
                              separatorBuilder: (context, index) => searchController.text.isNotEmpty ? myDivider(): Container(color: Colors.white,),
                              itemCount: cubit.model.data!.data!.length,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                );

        },
      ),
    );
  }

  Widget searchItemBuilder( Model model, context) =>

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                          model.image,
                        ),
                        width: 120,
                        height: 120,

                      ),
                      if ( isOldPrice)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.red,
                          child: Text(
                            'DISCOUNT',
                            style: TextStyle(
                                color: Colors.white, fontSize: 12),
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
                          model.name,
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
                            flex: 2,
                            child: Text(
                              '${model.price.round()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: defaultColor),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          if ( isOldPrice)
                            Text(
                              '${model.price.round()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black45,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          // Spacer(),
                          IconButton(

                            onPressed: () {
                             setState(() {
                               ShopCubit.get(context).changeFavorites(model.id);
                               ShopCubit.get(context).getFavorites();
                             });

                            },
                            icon: ShopCubit.get(context).favorites![model.id]! ? Icon(Icons.favorite,color: Colors.red, ) : Icon(Icons.favorite_border,color: defaultColor),

                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.add_shopping_cart,
                              size: 35,
                            ),
                          ),
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
