import '../error/failures.dart';

//wrapper hay : ya to Failure ya to data return karega
class Result<T> { // generic
  final T? data;
  final Failure? failure;
  final bool isSuccess;
  const Result._({this.data, this.failure, required this.isSuccess});
  factory Result.success(T data) => Result._(data: data, isSuccess: true);
  factory Result.failure(Failure failure) =>
      Result._(failure: failure, isSuccess: false);
  bool get isFailure => !isSuccess;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    if (isSuccess) {
      return onSuccess(data as T);
    }
    return onFailure(failure!);
  }
}