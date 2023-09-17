import 'package:flutter_test/flutter_test.dart';
import 'package:klsha/core/extensions/list.extension.dart';

void main() {
  test('should return a string seperated by commas from List<String>', () {
    final list = ['a', 'b', 'c'];
    expect(list.seperatedByComma, 'a, b, c');
  });
}
