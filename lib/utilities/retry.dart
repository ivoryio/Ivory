Future<T> retry<T>(
  Future<T> Function() fn, {
  int maxAttempts = 3,
  bool Function(T)? retryIf,
  Duration delay = const Duration(milliseconds: 500),
}) async {
  try {
    final result = await fn();

    if (retryIf != null && retryIf(result) && maxAttempts > 0) {
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
