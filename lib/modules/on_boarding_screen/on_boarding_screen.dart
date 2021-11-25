
import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}
class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
List<BoardingModel> boarding =[
  BoardingModel(image: 'assets/images/shopping4.jpg', title: 'From Anywhere', body: 'Search for what you need'),
  BoardingModel(image: 'assets/images/shopping5.jpg', title: 'Hot Offers', body: 'you will be noticed for our new offers'),
  BoardingModel(image: 'assets/images/shopping6.jpg', title: 'Express delivery', body: 'wherever you are, wee can reach you'),
];

var boardController = PageController();

bool isLast = false;
void submit(){
  CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
    if(value)navigateAndFinishTo(context, ShopLoginScreen());
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index){
                  if(index == boarding.length-1){
                    setState(() {
                      isLast=true;
                    });
                  }else{
                    setState(() {
                      isLast=false;
                    });
                  }
                },
                controller: boardController,
                  itemBuilder:(context,index)=>buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                physics: BouncingScrollPhysics(),
              ),
            ),
            SizedBox(height: 40,),
            SmoothPageIndicator(
              controller: boardController,
              count: boarding.length,
              effect: ExpandingDotsEffect(
                activeDotColor:defaultColor,
                dotColor: Colors.grey,
                dotHeight: 10,
                spacing: 5,
                dotWidth: 15,

              ),
            ),
            Row(
              children: [
                FloatingActionButton(
                  heroTag: 1,
                  onPressed: (){
                    submit();
                  },
                  child: Text(
                    'SKIP',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  backgroundColor: Colors.lightGreenAccent[400],
                ),
                Spacer(),
                FloatingActionButton(
                  heroTag: 2,
                  onPressed: (){
                    isLast ?
                    submit(): boardController.nextPage(duration: Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn );

                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }

  Widget buildBoardingItem(BoardingModel model)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),

        ),
      ),
      SizedBox(height: 30,),
      Text(
        '${model.title}',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900
        ),
      ),
      SizedBox(height: 15,),
      Text(
        '${model.body}',
        style: TextStyle(
            fontSize: 20,


        ),
      ),
      SizedBox(height: 30,),

    ],
  );
}
