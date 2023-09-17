import 'package:flutter_test/flutter_test.dart';
import 'package:klsha/core/http/error.dart';
import 'package:klsha/core/utils/either.dart';

void main() {
  group('Either', () {
    group('.Left', () {
      test('should return left value', () {
        const value = 'left';
        const either = Left(value);
        expect(either.isLeft, isTrue);
        expect(either.isRight, isFalse);
        expect(either.fold((_) => value, (_) => 'right'), value);
      });
    });
    group('.Right', () {
      test('should return right value', () {
        const value = 'right';
        const either = Right(value);
        expect(either.isLeft, isFalse);
        expect(either.isRight, isTrue);
        expect(either.fold((_) => 'left', (_) => value), value);
      });
    });

    group('.runAsyncBlock', () {
      test('should return right value', () async {
        const value = 10;
        final failureOrInt = await runAsyncBlock(() => Future.value(value));
        expect(failureOrInt.isLeft, isFalse);
        expect(failureOrInt.isRight, isTrue);
        expect(failureOrInt.right, value);
      });

      test('should return Failure', () async {
        const error = 'error';
        final failureOrInt =
            await runAsyncBlock(() => Future.error(UnexpectedException(error)));
        expect(failureOrInt.isLeft, isTrue);
        expect(failureOrInt.left.message, error);
      });
    });
  });
}
