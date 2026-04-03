import 'package:base_app/data/datasources/home_remote_datasource.dart';
import 'package:base_app/data/repositories/home_repository_impl.dart';
import 'package:base_app/domain/entities/home_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late MockHomeRemoteDataSource mockDataSource;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(mockDataSource);
  });

  group('loadHomeData', () {
    test(
      'returns Result.ok with HomeEntity when datasource succeeds',
      () async {
        when(
          () => mockDataSource.getMockHomeData(),
        ).thenAnswer(
          (_) async => {
            'message': 'Hello',
            'items': ['A', 'B'],
          },
        );

        final result = await repository.loadHomeData();

        expect(result.isOk, isTrue);
        expect(result.valueOrNull, isA<HomeEntity>());
        expect(result.valueOrNull?.message, 'Hello');
        expect(result.valueOrNull?.items, ['A', 'B']);
      },
    );

    test('returns Result.ok with defaults for missing JSON fields', () async {
      when(
        () => mockDataSource.getMockHomeData(),
      ).thenAnswer((_) async => <String, dynamic>{});

      final result = await repository.loadHomeData();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.message, '');
      expect(result.valueOrNull?.items, <String>[]);
    });

    test('returns Result.error when datasource throws', () async {
      when(
        () => mockDataSource.getMockHomeData(),
      ).thenThrow(Exception('Network failure'));

      final result = await repository.loadHomeData();

      expect(result.isError, isTrue);
      expect(result.valueOrNull, isNull);
    });
  });

  group('refreshHomeData', () {
    test('returns Result.ok when datasource succeeds', () async {
      when(
        () => mockDataSource.getMockHomeData(),
      ).thenAnswer(
        (_) async => {
          'message': 'Refreshed',
          'items': ['C'],
        },
      );

      final result = await repository.refreshHomeData();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.message, 'Refreshed');
      expect(result.valueOrNull?.items, ['C']);
    });

    test('returns Result.error when datasource throws', () async {
      when(
        () => mockDataSource.getMockHomeData(),
      ).thenThrow(Exception('Timeout'));

      final result = await repository.refreshHomeData();

      expect(result.isError, isTrue);
    });
  });
}
