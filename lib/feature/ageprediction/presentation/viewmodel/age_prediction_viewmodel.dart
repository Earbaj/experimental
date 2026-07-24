import 'package:flutter_riverpod/legacy.dart';
import 'package:untitled1/feature/ageprediction/presentation/viewmodel/state/age_prediction_state.dart';

import '../../domain/usecases/get_age_prediction_usecase.dart';

class AgePredictionViewModel extends StateNotifier<AgePredictionState> {
  final GetAgePredictionUseCase getAgePredictionUseCase;

  AgePredictionViewModel({
    required this.getAgePredictionUseCase,
  }) : super(AgePredictionState());

  void updateName(String name) {
    // Clear error when user starts typing
    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      state = state.copyWith(errorMessage: null);
    }
    state = state.copyWith(name: name);
  }

  void updateCountryId(String countryId) {
    state = state.copyWith(countryId: countryId);
  }

  Future<void> getAgePrediction() async {
    if (state.name.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a name');
      return;
    }

    // Clear previous results and errors
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      agePrediction: null,
    );

    try {
      final prediction = await getAgePredictionUseCase(
        state.name,
        state.countryId,
      );
      state = state.copyWith(
        isLoading: false,
        agePrediction: prediction,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        agePrediction: null,
      );
    }
  }

  void clearError() {
    // Clear error message while keeping other state
    if (state.errorMessage != null) {
      state = AgePredictionState(
        isLoading: state.isLoading,
        agePrediction: state.agePrediction,
        errorMessage: null,
        name: state.name,
        countryId: state.countryId,
      );
    }
  }

  // Alternative: Reset entire state
  void resetState() {
    state = AgePredictionState();
    // Also clear the text controller if you want
    // This should be handled in the view
  }
}