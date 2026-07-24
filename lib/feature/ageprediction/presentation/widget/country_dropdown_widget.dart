import 'package:flutter/material.dart';

class CountryDropdownWidget extends StatelessWidget {
  final String selectedCountry;
  final ValueChanged<String?> onChanged;

  const CountryDropdownWidget({
    Key? key,
    required this.selectedCountry,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      decoration: const InputDecoration(
        labelText: 'Country',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'US', child: Text('United States')),
        DropdownMenuItem(value: 'GB', child: Text('United Kingdom')),
        DropdownMenuItem(value: 'FR', child: Text('France')),
        DropdownMenuItem(value: 'DE', child: Text('Germany')),
        DropdownMenuItem(value: 'IN', child: Text('India')),
        DropdownMenuItem(value: 'JP', child: Text('Japan')),
        DropdownMenuItem(value: 'BR', child: Text('Brazil')),
      ],
      onChanged: onChanged,
    );
  }
}