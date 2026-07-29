import 'package:flutter/material.dart';

class Dimensions {

  // height and width
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  // page
  static double pageView(BuildContext context) => screenHeight(context) / 2.64;
  static double pageViewContainer(BuildContext context) => screenHeight(context) / 3.84;
  static double pageViewTextContainer(BuildContext context) => screenHeight(context) / 7.03;

  // font size
  static double fontSize16(BuildContext context) => screenHeight(context) / 52.75;
  static double fontSize20(BuildContext context) => screenHeight(context) / 42.2;
  static double fontSize26(BuildContext context) => screenHeight(context) / 32.46;

  // HEIGHTS
  static double height10(BuildContext context) => screenHeight(context) / 84.4;  // 844/10
  static double height20(BuildContext context) => screenHeight(context) / 42.2;  // 844/20

  // WIDTHS
  static double width10(BuildContext context) => screenWidth(context) / 39.27;  // 392.7/10
  static double width20(BuildContext context) => screenWidth(context) / 19.63;  // 392.7/20

  // popular image size
  static double popularImageSize(BuildContext context) => screenHeight(context) / 2.41;
}
