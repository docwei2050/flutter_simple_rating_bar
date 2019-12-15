import 'dart:ui';

import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final Widget icon;
  final double size;
  final bool allowHalfRating;
  final bool isIndicator;
  final double spacing;
  final ValueNotifier<double> _counter = ValueNotifier<double>(0.0);
  final ValueChanged onRatingCallback;

  RatingBar(
      {this.starCount = 5,
      this.rating = 0.0,
      this.color,
      this.icon,
      this.size,
      this.onRatingCallback,
      this.isIndicator = false,
      this.spacing = 0.0,
      this.allowHalfRating = true}) {
    assert(this.rating != null);
    assert(this.size != null);
  }

  Widget buildStar(BuildContext context, int index, double rating) {
    Container container;
    if (index >= rating) {
      //unselected stars
      container = Container(
        margin: EdgeInsets.only(right: spacing),
        width: size,
        height: size,
        child: icon,
      );
    } else if (index > rating - (allowHalfRating ? 0.5 : 1.0) &&
        index < rating) {
      //select a half of the star
      container = Container(
          margin: EdgeInsets.only(right: spacing),
          width: size,
          height: size,
          child: ClipRect(
            clipper: HalfClipper(),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcATop,
              ),
              child: icon,
            ),
          ));
    } else {
      //selected  stars
      container = Container(
        margin: EdgeInsets.only(right: spacing),
        width: size,
        height: size,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcATop,
          ),
          child: icon,
        ),
      );
    }

    return isIndicator ? container : GestureDetector(
            onTap: () {
              _counter.value = index.toDouble() + 1;
              if (onRatingCallback != null) {
                onRatingCallback(_counter.value);
              }
            },
            onHorizontalDragUpdate: (dragDetails) {
              RenderBox box = context.findRenderObject();
              var _pos = box.globalToLocal(dragDetails.globalPosition);
              var old = _pos.dx / size;
              //take the spacing into account。
              var i = (_pos.dx - (old + 1) * spacing) / size;
              double newRating = allowHalfRating ? i : i.round().toDouble();
              if (newRating > starCount) {
                newRating = starCount.toDouble();
              }
              if (newRating < 0) {
                newRating = 0.0;
              }
              _counter.value = newRating;

              if (onRatingCallback != null) {
                int value = newRating.toInt();
                if (allowHalfRating) {
                  if (newRating < value + 0.5) {
                    onRatingCallback(value + 0.5);
                  } else {
                    onRatingCallback(value + 1 > starCount ? starCount : value + 1);
                  }
                } else {
                  onRatingCallback(value > starCount ? starCount : value);
                }
              }
            },
            child: container,
          );
  }

  @override
  Widget build(BuildContext context) {
    _counter.value = rating;
    return new Material(
        color: Colors.transparent,
        child: ValueListenableBuilder(
            builder: (BuildContext context, double value, Widget child) {
              return Wrap(
                alignment: WrapAlignment.start,
                spacing: spacing,
                children: List.generate(
                    starCount, (index) => buildStar(context, index, value)),
              );
            },
            valueListenable: _counter));
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0.0,
      0.0,
      size.width / 2,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
