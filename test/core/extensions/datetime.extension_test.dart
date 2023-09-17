import 'package:flutter_test/flutter_test.dart';
import 'package:klsha/core/extensions/datetime.extension.dart';

void main() {
  test('should format date ', () {
    final DateTime date = DateTime(2023, 02, 02);
    expect(date.formattedStr, 'Thursday, February 2, 2023');
  });
}
