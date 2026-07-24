import '../../../domain/entity/age_prediction.dart';

class AgePredictionState {
  final bool isLoading;
  final AgePrediction? agePrediction;
  final String? errorMessage;
  final String name;
  final String countryId;

  AgePredictionState({
    this.isLoading = false,
    this.agePrediction,
    this.errorMessage,
    this.name = '',
    this.countryId = 'US',
  });

  AgePredictionState copyWith({
    bool? isLoading,
    AgePrediction? agePrediction,
    String? errorMessage,
    String? name,
    String? countryId,
  }) {
    return AgePredictionState(
      isLoading: isLoading ?? this.isLoading,
      agePrediction: agePrediction ?? this.agePrediction,
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      countryId: countryId ?? this.countryId,
    );
  }
}