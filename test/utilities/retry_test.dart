import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/utilities/retry.dart';

void main() {
  test('retry function should return the result if no exception is thrown', () async {
    int attempt = 0;
    final result = await retry<int>(
      () async {
        attempt++;
        return attempt;
      },
    );

    expect(result, 1);
  });

  test('retry function should retry if an exception is thrown', () async {
    int attempt = 0;
    final result = await retry<int>(
      () async {
        attempt++;
        if (attempt < 3) {
          throw Exception('Error');
        }
        return attempt;
      },
    );

    expect(result, 3);
  });

  test('retry function should not retry if maxAttempts is 0', () async {
    int attempt = 0;
    try {
      await retry<int>(
        () async {
          attempt++;
          throw Exception('Error');
        },
        maxAttempts: 0,
      );
    } catch (e) {
      expect(attempt, 1);
    }
  });

  test('retry function should retry if retryIf returns true', () async {
    int attempt = 0;
    final result = await retry<int>(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) => result < 3,
    );

    expect(result, 3);
  });

  test('retry function should not retry if retryIf returns false', () async {
    int attempt = 0;
    final result = await retry<int>(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) => result > 3,
    );

    expect(result, 1);
  });

  test('retry function should retry if retryIf returns true and maxAttempts is greater than 0', () async {
    int attempt = 0;
    final result = await retry<int>(
      () async {
        attempt++;
        return attempt;
      },
      retryIf: (result) => result < 3,
      maxAttempts: 5,
    );

    expect(result, 3);
  });
}
