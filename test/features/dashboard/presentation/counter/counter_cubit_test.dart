import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_forge/features/dashboard/presentation/counter/counter_cubit.dart';

void main() {
  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    test('initial state is 0', () {
      expect(counterCubit.state, equals(0));
    });

    group('increment', () {
      blocTest<CounterCubit, int>(
        'emits [1] when increment is called',
        build: () => CounterCubit(),
        act: (cubit) => cubit.increment(),
        expect: () => [1],
      );

      blocTest<CounterCubit, int>(
        'emits [1, 2, 3] when increment is called multiple times',
        build: () => CounterCubit(),
        act: (cubit) {
          cubit.increment();
          cubit.increment();
          cubit.increment();
        },
        expect: () => [1, 2, 3],
      );

      blocTest<CounterCubit, int>(
        'emits positive values when incrementing from negative',
        build: () => CounterCubit(),
        seed: () => -2,
        act: (cubit) {
          cubit.increment();
          cubit.increment();
          cubit.increment();
        },
        expect: () => [-1, 0, 1],
      );
    });

    group('decrement', () {
      blocTest<CounterCubit, int>(
        'emits [-1] when decrement is called',
        build: () => CounterCubit(),
        act: (cubit) => cubit.decrement(),
        expect: () => [-1],
      );

      blocTest<CounterCubit, int>(
        'emits [-1, -2, -3] when decrement is called multiple times',
        build: () => CounterCubit(),
        act: (cubit) {
          cubit.decrement();
          cubit.decrement();
          cubit.decrement();
        },
        expect: () => [-1, -2, -3],
      );

      blocTest<CounterCubit, int>(
        'emits negative values when decrementing from positive',
        build: () => CounterCubit(),
        seed: () => 2,
        act: (cubit) {
          cubit.decrement();
          cubit.decrement();
          cubit.decrement();
        },
        expect: () => [1, 0, -1],
      );
    });

    group('mixed operations', () {
      blocTest<CounterCubit, int>(
        'handles increment and decrement operations correctly',
        build: () => CounterCubit(),
        act: (cubit) {
          cubit.increment(); // 1
          cubit.increment(); // 2
          cubit.decrement(); // 1
          cubit.increment(); // 2
          cubit.decrement(); // 1
          cubit.decrement(); // 0
        },
        expect: () => [1, 2, 1, 2, 1, 0],
      );

      blocTest<CounterCubit, int>(
        'maintains correct state through complex operations',
        build: () => CounterCubit(),
        seed: () => 5,
        act: (cubit) {
          cubit.decrement(); // 4
          cubit.decrement(); // 3
          cubit.increment(); // 4
          cubit.increment(); // 5
          cubit.increment(); // 6
        },
        expect: () => [4, 3, 4, 5, 6],
      );
    });

    group('edge cases', () {
      test('can handle large positive numbers', () {
        counterCubit.emit(999999);
        counterCubit.increment();
        expect(counterCubit.state, equals(1000000));
      });

      test('can handle large negative numbers', () {
        counterCubit.emit(-999999);
        counterCubit.decrement();
        expect(counterCubit.state, equals(-1000000));
      });

      test('maintains state consistency after many operations', () {
        // Perform 100 increments then 100 decrements
        for (int i = 0; i < 100; i++) {
          counterCubit.increment();
        }
        expect(counterCubit.state, equals(100));
        
        for (int i = 0; i < 100; i++) {
          counterCubit.decrement();
        }
        expect(counterCubit.state, equals(0));
      });
    });
  });
}