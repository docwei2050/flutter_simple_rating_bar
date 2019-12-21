import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/rating_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}
class _MyAppState extends State<MyApp>{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child:  RatingBar(
                rating: 3,
                icon:Icon(Icons.star,size:40,color: Colors.grey,),
                starCount: 5,
                spacing: 5.0,
                size: 40,
                isIndicator: false,
                allowHalfRating: true,
                onRatingCallback: (double value,ValueNotifier<bool> isIndicator){
                  print('Number of stars-->  $value');
                  //change the isIndicator from false  to true ,the RatingBar cannot support touch event;
                  isIndicator.value=true;
                },
                clickedCallbackAsIndicator: (){
                  // when isIndicator is true ,user click the stars, this callback can be called.
                  print('clickedMe');
                },
                color: Colors.amber,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 60),
              child: RatingBar(
                rating: 3,
                icon:Icon(Icons.music_note,size: 45,color: Colors.grey),
                starCount: 5,
                spacing: 5.0,
                size: 45,
                isIndicator: true,
                allowHalfRating: true,
                onRatingCallback: (value,notifier){
                  //isIndicator:=true, so you dont need to  care this.
                },
                clickedCallbackAsIndicator: (){
                  print('clickMe');
                },
                color: Colors.amber,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 60),
              child: RatingBar(
                rating: 3,
                icon:Icon(Icons.stars,size: 45,color: Colors.grey),
                starCount: 5,
                spacing: 5.0,
                size: 45,
                isIndicator: false,
                allowHalfRating: true,
                onRatingCallback: (value,notifier){
                  //isIndicator:=true, so you dont need to  care this.
                },
                color: Colors.amber,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState(() {
            });
          },
        ),),
    );
  }


}

