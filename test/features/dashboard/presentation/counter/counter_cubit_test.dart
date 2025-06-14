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

    test('increment increases state by 1', () {
      counterCubit.increment();
      expect(counterCubit.state, equals(1));

      counterCubit.increment();
      expect(counterCubit.state, equals(2));
    });

    test('decrement decreases state by 1', () {
      counterCubit.decrement();
      expect(counterCubit.state, equals(-1));

      counterCubit.decrement();
      expect(counterCubit.state, equals(-2));
    });

    test('multiple operations work correctly', () {
      counterCubit.increment(); // 1
      counterCubit.increment(); // 2
      counterCubit.decrement(); // 1
      counterCubit.increment(); // 2
      counterCubit.decrement(); // 1
      expect(counterCubit.state, equals(1));
    });

    blocTest<CounterCubit, int>(
      'cubit emits states in correct order',
      build: CounterCubit.new,
      act: (cubit) => {
        cubit.increment(), // 1
        cubit.increment(), // 2
        cubit.decrement(), // 1
        cubit.decrement(), // 0
        cubit.decrement(), // -1
      },
      expect: () => [1, 2, 1, 0, -1],
    );
  });
}
