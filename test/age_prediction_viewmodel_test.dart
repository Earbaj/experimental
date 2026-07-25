import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:untitled1/feature/ageprediction/domain/entity/age_prediction.dart';
import 'package:untitled1/feature/ageprediction/domain/usecases/get_age_prediction_usecase.dart';
import 'package:untitled1/feature/ageprediction/presentation/viewmodel/age_prediction_viewmodel.dart';
import 'package:untitled1/feature/ageprediction/presentation/viewmodel/state/age_prediction_state.dart';


// 1. Create a Mock for the UseCase
class MockGetAgePredictionUseCase extends Mock implements GetAgePredictionUseCase {}

void main() {
  late AgePredictionViewModel viewModel;
  late MockGetAgePredictionUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetAgePredictionUseCase();
    viewModel = AgePredictionViewModel(getAgePredictionUseCase: mockUseCase);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('AgePredictionViewModel - State Updates', () {
    test('initial state should be default AgePredictionState', () {
      expect(viewModel.state, equals(AgePredictionState()));
    });

    test('updateName updates name in state and clears existing error', () {
      // Set an initial error state
      viewModel.getAgePrediction(); // Triggers empty name error

      viewModel.updateName('John');

      expect(viewModel.state.name, equals('John'));
      expect(viewModel.state.errorMessage, "Please enter a name");
    });

    test('updateCountryId updates countryId in state', () {
      viewModel.updateCountryId('US');

      expect(viewModel.state.countryId, equals('US'));
    });
  });

  group('AgePredictionViewModel - getAgePrediction', () {
    test('sets error message when name is empty without calling UseCase', () async {
      await viewModel.getAgePrediction();

      expect(viewModel.state.errorMessage, equals('Please enter a name'));
      verifyNever(() => mockUseCase(any(), any()));
    });

    test('updates state with prediction on success', () async {
      final fakeResult = AgePrediction(count: 0, name: 'Alice', age: 28, countryId: 'US'); // Replace with mock/real instance
      viewModel.updateName('Alice');
      viewModel.updateCountryId('US');

      when(() => mockUseCase('Alice', 'US')).thenAnswer((_) async => fakeResult);

      final future = viewModel.getAgePrediction();

      // Check loading state mid-execution
      expect(viewModel.state.isLoading, isTrue);

      await future;

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.agePrediction, equals(fakeResult));
      expect(viewModel.state.errorMessage, isNull);
      verify(() => mockUseCase('Alice', 'US')).called(1);
    });

    test('updates state with error message on UseCase failure', () async {
      viewModel.updateName('Alice');
      viewModel.updateCountryId('US');

      when(() => mockUseCase('Alice', 'US')).thenThrow(Exception('Network error'));

      await viewModel.getAgePrediction();

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.agePrediction, isNull);
      expect(viewModel.state.errorMessage, contains('Network error'));
    });
  });

  group('AgePredictionViewModel - Resets & Clears', () {
    test('clearError resets error message while keeping other state values intact', () {
      viewModel.updateName('John');
      viewModel.getAgePrediction(); // triggers error check or error path

      // Simulate state with error
      viewModel.updateName('');
      viewModel.getAgePrediction(); // error: 'Please enter a name'

      viewModel.clearError();

      expect(viewModel.state.errorMessage, isNull);
    });

    test('resetState returns state to default initial state', () {
      viewModel.updateName('John');
      viewModel.updateCountryId('CA');

      viewModel.resetState();

      expect(viewModel.state.name, equals(''));
      expect(viewModel.state.countryId, equals('US'));
      expect(viewModel.state.isLoading, isFalse);
    });
  });
}