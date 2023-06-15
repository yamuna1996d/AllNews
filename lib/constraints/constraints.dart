import 'package:flutter/material.dart';

//String NY_API_KEY = "2UPL0kTZKyXwedWGnXHVwAkRP9bJQeH1";
String API_KEY = "f9dc718c8e734914a74994211ba10f06";

double fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

const Color dimBlack = Color(0xff656567);
const grey1 = Color(0xFF0A0A0A);
const grey2 = Color(0xFFEAEAEA);
const mainColor = Color(0xCFF1D8D8);
const backgroundColor = Color(0xFFFAFAFA);
const blackColor = Color(0xFF121212);
const greyColor = Color(0xFF8F8E8E);
const lightGreyColor = Color(0xFFF4F4F4);
const whiteColor = Color(0xFFFFFFFF);

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}


