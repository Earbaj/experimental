import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/inject_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state to react to changes (loading, error, success)
    final loginState = ref.watch(loginProvider);

    // Listen for errors to show SnackBars
    ref.listen(loginProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      if (next.user != null) {
        // Navigate to Home or Profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Clean Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username (emilys)"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password (emilyspass)"),
            ),
            const SizedBox(height: 32),

            // Show loader or button
            loginState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();

                if (username.isNotEmpty && password.isNotEmpty) {
                  // Call the ViewModel
                  ref.read(loginProvider.notifier).login(username, password);
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}