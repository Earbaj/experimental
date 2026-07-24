import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injectProvider.dart';
import '../widget/age_prediction_result_widget.dart';
import '../widget/country_dropdown_widget.dart';


class AgePredictionView extends ConsumerStatefulWidget {
  const AgePredictionView({Key? key}) : super(key: key);

  @override
  ConsumerState<AgePredictionView> createState() => _AgePredictionViewState();
}

class _AgePredictionViewState extends ConsumerState<AgePredictionView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(agePredictionViewModelProvider.notifier);
    final state = ref.watch(agePredictionViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Predictor'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => viewModel.updateName(value),
            ),
            const SizedBox(height: 16),

            // Country Dropdown
            CountryDropdownWidget(
              selectedCountry: state.countryId,
              onChanged: (value) {
                if (value != null) {
                  viewModel.updateCountryId(value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: state.isLoading ? null : viewModel.getAgePrediction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: state.isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text('Predict Age'),
            ),
            const SizedBox(height: 16),

            // Error Message
            if (state.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: viewModel.clearError,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

            // Result
            if (state.agePrediction != null)
              AgePredictionResultWidget(prediction: state.agePrediction!),
          ],
        ),
      ),
    );
  }
}