import 'package:flutter/material.dart';

class Dimensions {
  /// Retrieves the current screen height.
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Retrieves the current screen width.
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  // Page view dimensions.
  static double pageViewContainer(BuildContext context) =>
      screenHeight(context) / 3.84;
  static double pageViewTextContainer(BuildContext context) =>
      screenHeight(context) / 7.03;
  static double pageView(BuildContext context) =>
      screenHeight(context) / 2.64;

  // Dynamic height values.
  static double height10(BuildContext context) =>
      screenHeight(context) / 85.09;
  static double height15(BuildContext context) =>
      screenHeight(context) / 56.72;
  static double height20(BuildContext context) =>
      screenHeight(context) / 42.54;
  static double height30(BuildContext context) =>
      screenHeight(context) / 28.36;
  static double height45(BuildContext context) =>
      screenHeight(context) / 18.909;

  // Dynamic width values.
  static double width10(BuildContext context) =>
      screenWidth(context) / 39.272;
  static double width15(BuildContext context) =>
      screenWidth(context) / 26.18;
  static double width20(BuildContext context) =>
      screenWidth(context) / 19.63;
  static double width30(BuildContext context) =>
      screenWidth(context) / 13.09;
  static double width45(BuildContext context) =>
      screenWidth(context) / 8.72;

  // Font sizes.
  static double font16(BuildContext context) =>
      screenHeight(context) / 53.18;
  static double font20(BuildContext context) =>
      screenHeight(context) / 42.54;
  static double font26(BuildContext context) =>
      screenHeight(context) / 32.46;

  // Radius values.
  static double radius15(BuildContext context) =>
      screenHeight(context) / 56.27;
  static double radius20(BuildContext context) =>
      screenHeight(context) / 42.54;
  static double radius30(BuildContext context) =>
      screenHeight(context) / 28.36;

  // Icon sizes.
  static double iconSize16(BuildContext context) =>
      screenHeight(context) / 52.75;
  static double iconSize24(BuildContext context) =>
      screenHeight(context) / 35.17;

  // List View sizes.
  static double listviewImgSize(BuildContext context) =>
      screenWidth(context) / 3.25;
  static double listviewTextContainerSize(BuildContext context) =>
      screenWidth(context) / 3.9;

  // Popular food image size.
  static double popularFoodImgSize(BuildContext context) =>
      screenHeight(context) / 2.41;

  // Bottom height bar.
  static double bottomHeightBar(BuildContext context) =>
      screenHeight(context) / 7.03;

  // Splash screen image size.
  static double splashImage(BuildContext context) =>
      screenHeight(context) / 3.38;
}
