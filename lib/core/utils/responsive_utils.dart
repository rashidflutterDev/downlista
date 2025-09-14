import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double paddingScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 375;
  }

  static double fontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 375;
  }

  static double spacingScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 375;
  }

  static double componentScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 375;
  }
}
