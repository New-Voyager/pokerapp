import 'package:sizer/sizer.dart';

const double mockupWidth = 375.5;
const double mockupHeight = 812.0;
double textScaleFactor = 1.5;

extension PercentWidth on double {
  double get pt => ((this / mockupWidth) * 100).w;
}

extension PercentWidthOnInt on int {
  double get pt => this.toDouble().pt;
}

extension PXtoSP on double {
  double get dp => this * textScaleFactor;
}

extension PXtoSPOnInt on int {
  double get dp => this.toDouble().dp;
}
