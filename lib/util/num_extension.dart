import 'dart:math';

extension RangeNum on num {
  bool isInRange(num index, num range) {
    return index - range < this && this < index + range;
  }
}

extension DoubleExtension on double {
  double roundTo(int places) {
    num mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}
