import 'package:base_app/config/error/result_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.ok', () {
    test('creates an Ok instance', () {
      final result = Result.ok(42);

      expect(result, isA<Ok<int>>());
      expect(result.isOk, isTrue);
      expect(result.isError, isFalse);
    });

    test('valueOrNull returns value', () {
      final result = Result.ok('hello');

      expect(result.valueOrNull, 'hello');
    });
  });

  group('Result.error', () {
    test('creates an Error instance', () {
      final result = Result<int>.error(Exception('fail'));

      expect(result, isA<Error<int>>());
      expect(result.isError, isTrue);
      expect(result.isOk, isFalse);
    });

    test('valueOrNull returns null', () {
      final result = Result<String>.error(Exception('fail'));

      expect(result.valueOrNull, isNull);
    });
  });

  group('when', () {
    test('calls ok callback for Ok result', () {
      final result = Result.ok(10);
      var called = false;

      result.when(
        ok: (value) {
          called = true;
          expect(value, 10);
          return value;
        },
        error: (e) => 0,
      );

      expect(called, isTrue);
    });

    test('calls error callback for Error result', () {
      final exception = Exception('test error');
      final result = Result<int>.error(exception);
      var called = false;

      result.when(
        ok: (value) => value,
        error: (e) {
          called = true;
          expect(e, exception);
          return 0;
        },
      );

      expect(called, isTrue);
    });

    test('returns value from ok callback', () {
      final result = Result.ok(5);

      final doubled = result.when(
        ok: (value) => value * 2,
        error: (e) => 0,
      );

      expect(doubled, 10);
    });
  });

  group('whenAsync', () {
    test('calls async ok callback for Ok result', () async {
      final result = Result.ok('data');

      final upper = await result.whenAsync(
        ok: (value) async => value.toUpperCase(),
        error: (e) async => '',
      );

      expect(upper, 'DATA');
    });

    test('calls async error callback for Error result', () async {
      final result = Result<String>.error(Exception('fail'));

      final fallback = await result.whenAsync(
        ok: (value) async => value,
        error: (e) async => 'fallback',
      );

      expect(fallback, 'fallback');
    });
  });
}
