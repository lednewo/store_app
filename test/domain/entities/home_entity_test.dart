import 'package:base_app/domain/entities/home_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const entity1 = HomeEntity(
    message: 'Hello',
    items: ['A', 'B'],
  );

  const entity2 = HomeEntity(
    message: 'Hello',
    items: ['A', 'B'],
  );

  const entityDifferentMessage = HomeEntity(
    message: 'World',
    items: ['A', 'B'],
  );

  const entityDifferentItems = HomeEntity(
    message: 'Hello',
    items: ['C'],
  );

  group('equality', () {
    test('two entities with same values are equal', () {
      expect(entity1, equals(entity2));
    });

    test('entities with different message are not equal', () {
      expect(entity1, isNot(equals(entityDifferentMessage)));
    });

    test('entities with different items are not equal', () {
      expect(entity1, isNot(equals(entityDifferentItems)));
    });

    test('identical entity is equal to itself', () {
      expect(entity1, equals(entity1));
    });
  });

  group('hashCode', () {
    test('two equal entities have same hashCode', () {
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('different entities have different hashCode', () {
      expect(
        entity1.hashCode,
        isNot(equals(entityDifferentMessage.hashCode)),
      );
    });
  });

  group('copyWith', () {
    test('creates copy with updated message', () {
      final copy = entity1.copyWith(message: 'New');

      expect(copy.message, 'New');
      expect(copy.items, entity1.items);
    });

    test('creates copy with updated items', () {
      final copy = entity1.copyWith(items: ['X']);

      expect(copy.message, entity1.message);
      expect(copy.items, ['X']);
    });

    test('creates identical copy when no params provided', () {
      final copy = entity1.copyWith();

      expect(copy, equals(entity1));
    });
  });

  group('toString', () {
    test('returns readable representation', () {
      expect(
        entity1.toString(),
        'HomeEntity(message: Hello, items: [A, B])',
      );
    });
  });
}
