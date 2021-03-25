import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krushapp/utils/circleProgressBarPainter.dart';

class CircleProgressBar extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;
  final Function onPageChanged;

  const CircleProgressBar(
      {Key key,
      this.backgroundColor,
      @required this.foregroundColor,
      @required this.value,
      @required this.onPageChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor;
    final foregroundColor = this.foregroundColor;
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        child: Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
              onTap: () => this.onPageChanged(),
              child: FloatingActionButton(
                heroTag: 'fab',
                child: Icon(Icons.arrow_forward_ios,
                color: Colors.white,
                size: 30,
                ),
                onPressed: onPageChanged) 
            )),
        foregroundPainter: CircleProgressBarPainter(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            percentage: this.value,
            strokeWidth: 3),
      ),
    );
  }
}
