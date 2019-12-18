import 'dart:ui';

import 'package:flutter/material.dart';

typedef RatingChangeCallBack<T> = void Function(
    double value, ValueNotifier<bool> isIndicator);

class RatingBarNew extends StatefulWidget {
  final int starCount;
  final double rating;
  final Color color;
  final Widget icon;
  final double size;
  final bool allowHalfRating;
  final bool isIndicator;
  final double spacing;
  final RatingChangeCallBack onRatingCallback;

  RatingBarNew(
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

  @override
  State<StatefulWidget> createState() {
    return _RatingBarNewState();
  }
}

class _RatingBarNewState extends State<RatingBarNew> {
  final ValueNotifier<double> _ratingNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> _isIndicatorNotifier = ValueNotifier<bool>(false);
  double _rating;
  bool _isIndicator;

  @override
  void initState() {
    super.initState();
    _isIndicator = widget.isIndicator;
    _rating = widget.rating;

  }

  @override
  Widget build(BuildContext context) {
    print('build----${_rating}');
    print('build----${_isIndicator}');
    /*_isIndicatorNotifier.value = _isIndicator;
    _ratingNotifier.value = _rating;*/
    return new Material(
        color: Colors.transparent,
        child: ValueListenableBuilder(
            builder: (BuildContext context, bool isIndicator, Widget child) {
              return ValueListenableBuilder(
                  builder: (BuildContext context, double value, Widget child) {
                    return Wrap(
                      alignment: WrapAlignment.start,
                      spacing: widget.spacing,
                      children: List.generate(
                          widget.starCount,
                          (index) =>
                              buildStar(context, index, value, isIndicator)),
                    );
                  },
                  valueListenable: _ratingNotifier);
            },
            valueListenable: _isIndicatorNotifier));
  }

  Widget buildStar(
      BuildContext context, int index, double rating, bool isIndicator) {
    Container container;
    if (index >= rating) {
      //unselected stars
      container = Container(
        margin: EdgeInsets.only(right: widget.spacing),
        width: widget.size,
        height: widget.size,
        child: widget.icon,
      );
    } else if (index > rating - (widget.allowHalfRating ? 0.5 : 1.0) && index < rating) {
      //select a half of the star
      container = Container(
          margin: EdgeInsets.only(right: widget.spacing),
          width: widget.size,
          height: widget.size,
          child: ClipRect(
            clipper: HalfClipper(),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                widget.color,
                BlendMode.srcATop,
              ),
              child: widget.icon,
            ),
          ));
    } else {
      //selected  stars
      container = Container(
        margin: EdgeInsets.only(right: widget.spacing),
        width: widget.size,
        height: widget.size,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            widget.color,
            BlendMode.srcATop,
          ),
          child: widget.icon,
        ),
      );
    }

    return isIndicator ? container : GestureDetector(
            onTap: () {
              double value = index.toDouble() + 1;
              if (widget.onRatingCallback != null) {
                widget.onRatingCallback(value, _isIndicatorNotifier);
              }
              _ratingNotifier.value = value;
            },
            onHorizontalDragUpdate: (dragDetails) {
              RenderBox box = context.findRenderObject();
              var _pos = box.globalToLocal(dragDetails.globalPosition);
              var old = _pos.dx / widget.size;
              //take the spacing into account。
              double i = (_pos.dx - (old-1)* widget.spacing) / widget.size;
              double newRating = widget.allowHalfRating ? i : i.round().toDouble();
              if (newRating > widget.starCount) {
                newRating = widget.starCount.toDouble();
              }
              if (newRating < 0) {
                newRating = 0.0;
              }
              if (widget.onRatingCallback != null) {
                int value = newRating.toInt();
                if (widget.allowHalfRating) {
                  if (newRating < value + 0.5) {
                    widget.onRatingCallback(value + 0.5, _isIndicatorNotifier);
                  } else {
                    widget.onRatingCallback(value + 1 > widget.starCount ? widget.starCount.toDouble() : value + 1, _isIndicatorNotifier);
                  }
                } else {
                  widget.onRatingCallback(value > widget.starCount ? widget.starCount.toDouble() : value, _isIndicatorNotifier);
                }
              }
              _ratingNotifier.value = newRating;
            },
            child: container,
          );
  }

  @override
  void dispose() {
    super.dispose();
    _isIndicatorNotifier?.dispose();
    _ratingNotifier?.dispose();
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
