import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);
  Widget pOnly({
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    ),
    child: this,
  );
  Widget expanded([int flex = 1]) => Expanded(flex: flex, child: this);
  Widget wh(double w, double h) => SizedBox(width: w, height: h, child: this);
  Widget wrapCenter() => Center(child: this);
}

extension NumExtensions on num {
  Widget get heightBox => SizedBox(height: toDouble());
  Widget get widthBox => SizedBox(width: toDouble());
}
