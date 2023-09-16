import 'package:equatable/equatable.dart';
import 'package:klasha_assessment/core/http/error.dart';
import 'package:klasha_assessment/core/utils/safe_print.dart';

/// A convenience class for handling a value that can be either of two options.
/// This class is typically used to represent the result of an operation
/// which can be either failed or successful.
abstract class Either<L, R> extends Equatable {
  const Either();

  E fold<E>(E Function(L) ifLeft, E Function(R) ifRight);

  bool get isLeft => fold((_) => true, (_) => false);

  bool get isRight => fold((_) => false, (_) => true);

  L get left => fold((leftValue) => leftValue,
      (_) => throw UnimplementedError("Either::left"));

  R get right => fold((_) => throw UnimplementedError("Either::right"),
      (rightValue) => rightValue);
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifLeft(value);

  @override
  List<Object?> get props => [value];
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  E fold<E>(E Function(L value) ifLeft, E Function(R value) ifRight) =>
      ifRight(value);

  @override
  List<Object?> get props => [value];
}

Future<Either<Failure, T>> runAsyncBlock<T>(Future<T> Function() future) async {
  try {
    final result = await future();
    return Right(result);
  } on AppException catch (e) {
    safePrint(e);
    return Left(Failure(e));
  } catch (e) {
    safePrint(e);
    return Left(Failure.fromStr('An unknown error occurred'));
  }
}
