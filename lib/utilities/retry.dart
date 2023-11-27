Future<T> retry<T>(
  Future<T> Function() fn, {
  int retries = 3,
  bool Function(T)? retryIf,
  Duration delay = const Duration(milliseconds: 500),
}) async {
  try {
    final result = await fn();

    if (retryIf != null && retryIf(result) && retries > 0) {
      await Future.delayed(delay);
      return retry(fn, retries: retries - 1, retryIf: retryIf, delay: delay);
    }

    return result;
  } catch (error) {
    if (retries > 0) {
      await Future.delayed(delay);

      return retry(fn, retries: retries - 1, retryIf: retryIf, delay: delay);
    } else {
      rethrow;
    }
  }
}
