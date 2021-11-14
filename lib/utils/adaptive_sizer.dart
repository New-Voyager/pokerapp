import 'package:sizer/sizer.dart';

// const double mockupWidth = 375.5;
// const double mockupHeight = 812.0;
double textScaleFactor = 1.5;

extension PercentWidth on double {
  double get pw => this; // ((this / mockupWidth) * 100).w;
}

extension PercentHeight on double {
  double get ph => this; // ((this / mockupHeight) * 100).h;
}

extension PercentWidthOnInt on int {
  double get pw => this.toDouble().pw;
}

extension PercentHeightOnInt on int {
  double get ph => this.toDouble().ph;
}

extension PXtoSP on double {
  double get dp => this * textScaleFactor;
}

extension PXtoSPOnInt on int {
  double get dp => this.toDouble().dp;
}
