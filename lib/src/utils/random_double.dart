import 'dart:math';

extension RandomX on Random {
  double randomDouble(double min, double max) {
    return min + nextDouble() * (max - min);
  }
}
