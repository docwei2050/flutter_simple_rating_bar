import 'dart:ui';

import 'package:flutter/material.dart';

typedef RatingChangeCallBack<T> = void Function(
    double value, ValueNotifier<bool> isIndicator);

class RatingBar extends StatefulWidget {
  final int starCount;
  final double rating;
  final Color color;
  final Widget icon;
  final double size;
  final bool allowHalfRating;
  final bool isIndicator;
  final double spacing;
  final RatingChangeCallBack onRatingCallback;
  final VoidCallback clickedCallbackAsIndicator;

  RatingBar(
      {this.starCount = 5,
      this.rating = 0.0,
      this.color,
      this.icon,
      this.size,
      this.onRatingCallback,
      this.clickedCallbackAsIndicator,
      this.isIndicator = false,
      this.spacing = 0.0,
      this.allowHalfRating = true}) {
    assert(this.rating != null);
    assert(this.size != null);
  }

  @override
  State<StatefulWidget> createState() {
    return _RatingBarState();
  }
}

class _RatingBarState extends State<RatingBar> {
  ValueNotifier<double> _ratingNotifier;

  ValueNotifier<bool> _isIndicatorNotifier;
  double _rating;
  bool _isIndicator;
  List halfs = List();
  List fulls = List();

  @override
  void initState() {
    super.initState();
    _isIndicator = widget.isIndicator;
    _rating = widget.rating;
    _ratingNotifier = ValueNotifier<double>(_rating);
    _isIndicatorNotifier = ValueNotifier<bool>(_isIndicator);

    assembleListForFullRating();
    assembleListForHalfRating();
  }

  @override
  Widget build(BuildContext context) {
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
    } else if ((index >= rating - (widget.allowHalfRating ? 0.5 : 1.0) &&
            index < rating) &&
        widget.allowHalfRating) {
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

    return isIndicator
        ? GestureDetector(
            onTap: () {
              if (widget.clickedCallbackAsIndicator != null) {
                widget.clickedCallbackAsIndicator();
              }
            },
            child: container,
          )
        : GestureDetector(
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
              double newRating = widget.allowHalfRating
                  ? getHalfRating(_pos.dx)
                  : getFullRating(_pos.dx);
              if (newRating > widget.starCount) {
                newRating = widget.starCount.toDouble();
              }
              if (newRating < 0) {
                newRating = 0.0;
              }
              if (widget.onRatingCallback != null) {
                widget.onRatingCallback(newRating, _isIndicatorNotifier);
              }
              _ratingNotifier.value = newRating;
            },
            child: container,
          );
  }

  assembleListForHalfRating() {
    for (int i = 1; i <= widget.starCount + 1; i++) {
      halfs.add((widget.size + widget.spacing) * (i - 1) + widget.size / 4);
      halfs.add((widget.size + widget.spacing) * (i - 1) + widget.size * 3 / 4);
    }
  }

  assembleListForFullRating() {
    for (int i = 1; i <= widget.starCount + 1; i++) {
      fulls.add((widget.size + widget.spacing) * (i - 1) + widget.size / 2);
    }
  }

  double getHalfRating(double dx) {
    int low = 0;
    int high = halfs.length - 1;
    int middle = 0;
    int key = 0;
    if (dx < halfs[low]) {
      key = 0;
    }
    if (dx > halfs[high]) {
      key = halfs.length;
    }
    while (low <= high) {
      middle = (low + high) ~/ 2;

      if (halfs[middle] > dx) {
        high = middle - 1;
      } else if (halfs[middle] < dx) {
        low = middle + 1;
      }
    }
    key = high;
    return key / 2;
  }

  double getFullRating(double dx) {
    int low = 0;
    int high = fulls.length - 1;
    int middle = 0;
    int key = 0;
    if (dx < fulls[low]) {
      key = 0;
    }
    if (dx > fulls[high]) {
      key = fulls.length;
    }
    while (low <= high) {
      middle = (low + high) ~/ 2;
      if (fulls[middle] > dx) {
        high = middle - 1;
      } else if (fulls[middle] < dx) {
        low = middle + 1;
      }
    }
    key = low;
    return key.toDouble();
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
