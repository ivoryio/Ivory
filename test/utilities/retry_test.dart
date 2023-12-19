import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/utilities/retry.dart';

void main() {
  test('retry function should return the result if no exception is thrown', () async {
    // given
    int attempt = 0;
    int callback() {
      attempt++;
      return attempt;
    }

    // when
    final result = await retry(
      callback,
    );
    // then
    expect(result, 1);
  });

  test('retry function should retry if an exception is thrown', () async {
    // given
    int attempt = 0;
    // when
    final result = await retry(
      () async {
        attempt++;
        if (attempt < 3) {
          throw Exception('Error');
        }
        return attempt;
      },
    );
    // then
    expect(result, 3);
  });

  test('retry function should not retry if maxAttempts is 0', () async {
    // given
    int attempt = 0;
    // when
    try {
      await retry(
        () async {
          attempt++;
          throw Exception('Error');
        },
        maxAttempts: 0,
      );
    } catch (e) {
      // then
      expect(attempt, 1);
    }
  });

  test('retry function should retry if retryIf returns true', () async {
    // given
    int attempt = 0;
    // when
    final result = await retry(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) => result < 3,
    );
    // then
    expect(result, 3);
  });

  test('retry function should not retry if retryIf returns false', () async {
    // given
    int attempt = 0;
    // when
    final result = await retry(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) => result > 3,
    );
    // then
    expect(result, 1);
  });

  test("retry function should retry if retryIf is a Future and returns true", () async {
    // given
    int attempt = 0;
    // when
    final result = await retry(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) async {
        return result < 3;
      },
    );
    // then
    expect(result, 3);
  });

  test('retry function should retry if retryIf returns true and maxAttempts is greater than 0', () async {
    // given
    int attempt = 0;
    // when
    final result = await retry(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) => result < 3,
      maxAttempts: 5,
    );
    // then
    expect(result, 3);
  });
}
