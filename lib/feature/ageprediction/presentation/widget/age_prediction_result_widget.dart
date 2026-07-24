import 'package:flutter/material.dart';

import '../../domain/entity/age_prediction.dart';

class AgePredictionResultWidget extends StatelessWidget {
  final AgePrediction prediction;

  const AgePredictionResultWidget({Key? key, required this.prediction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Age Prediction for ${prediction.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  'Age',
                  '${prediction.age}',
                  Icons.cake,
                ),
                _buildInfoItem(
                  'Count',
                  '${prediction.count}',
                  Icons.people,
                ),
                _buildInfoItem(
                  'Country',
                  prediction.countryId,
                  Icons.location_on,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}