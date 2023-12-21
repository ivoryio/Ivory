import 'dart:async';

Future<T> retry<T>(
  FutureOr<T> Function() fn, {
  int maxAttempts = 3,
  FutureOr<bool> Function(T)? retryIf,
  Duration delay = const Duration(milliseconds: 500),
}) async {
  try {
    final result = await fn();

    if (retryIf != null && await retryIf(result) && maxAttempts > 0) {
      await Future.delayed(delay);
      return retry(fn, maxAttempts: maxAttempts - 1, retryIf: retryIf, delay: delay);
    }

    return result;
  } catch (error) {
    if (maxAttempts > 0) {
      await Future.delayed(delay);

      return retry(fn, maxAttempts: maxAttempts - 1, retryIf: retryIf, delay: delay);
    } else {
      rethrow;
    }
  }
}
