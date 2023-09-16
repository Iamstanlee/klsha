// coverage:ignore-file
import 'package:equatable/equatable.dart';

abstract class AppException with EquatableMixin implements Exception {
  String get message;

  @override
  List<Object?> get props => [message];
}

class ServerException extends AppException {
  final String msg;

  ServerException(this.msg);

  @override
  String get message => msg;
}

class TimeoutServerException extends AppException {
  @override
  String get message => 'connection timeout';
}

class UnexpectedServerException extends AppException {
  @override
  String get message => 'unexpected error occurred';
}

class InvalidArgOrDataException extends AppException {
  @override
  String get message => 'invalid argument or data';
}

class UnexpectedException extends AppException {
  final String msg;

  UnexpectedException(this.msg);

  @override
  String get message => msg;
}

class Failure extends Equatable {
  final AppException _exception;

  const Failure(this._exception);

  factory Failure.fromStr(String msg) => Failure(UnexpectedException(msg));

  String get message => _exception.message;

  @override
  String toString() {
    return '${_exception.runtimeType} Failure: $message';
  }

  @override
  List<Object?> get props => [message];
}
