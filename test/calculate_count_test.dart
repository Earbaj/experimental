import 'package:flutter_test/flutter_test.dart';
import 'package:untitled1/feature/calculate_count.dart';

void main(){
  group("Calculator functionality test", () {
    test("Should return 10% value", () {
      final calculate = CalculateCount();
      final result = calculate.calculateVat(100);
      expect(result, 10.0);
    });
    test("Should return 0 when value are negative", () {
      final calculate = CalculateCount();
      final result = calculate.calculateVat(-50.0);
      expect(result, 0.0);
    });
  });
}