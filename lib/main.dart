import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/rating_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
               size: 50,
               allowHalfRating: true,
               onRatingCallback: (value){
                 print('Number of stars-->  $value');
               },
               color: Colors.amber,
             ),
           ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 100),
              child: RatingBar(
                rating: 3,
                icon:Icon(Icons.music_note,size: 45,color: Colors.grey),
                starCount: 5,
                spacing: 5.0,
                size: 45,
                isIndicator: true,
                allowHalfRating: true,
                onRatingCallback: (value){
                  //isIndicator:=true, so you dont need to  care this.
                },
                color: Colors.amber,
              ),
            )
          ],
        ),
      ),
    );
  }
}

