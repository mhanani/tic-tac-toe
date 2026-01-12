import 'package:equatable/equatable.dart';

/// Base failure class for all failures in the app
abstract class Failure extends Equatable {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const Failure({required this.message, this.error, this.stackTrace});

  @override
  List<Object?> get props => [message, error];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.error, super.stackTrace});
}

class GameFailure extends Failure {
  const GameFailure({required super.message, super.error, super.stackTrace});
}

class SettingsFailure extends Failure {
  const SettingsFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}
