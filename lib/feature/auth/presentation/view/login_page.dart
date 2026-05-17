import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injectProvider.dart';
import '../event/login_event.dart';
import '../state/login_state.dart';
import '../viewmodel/login_block.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with BLoC')),
      // ১. BlocProvider দিয়ে স্ক্রিনে Bloc ইনজেক্ট করা (GetIt থেকে ইন্সট্যান্স নিয়ে)
      body: BlocProvider(
        create: (_) => sl<LoginBloc>(),
        child: BlocConsumer<LoginBloc, LoginState>(
          // listener দিয়ে Dialog, Snackbar বা Navigation হ্যান্ডেল করা হয় (স্টেট চেঞ্জ হলে একবারই চলে)
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is LoginSuccess) {
              // Navigate to Home Screen
              print("Login Success: ${state.user.firstName} ${state.user.lastName}");
            }
          },
          // builder দিয়ে UI রি-বিল্ড করা হয়
          builder: (context, state) {

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username',hintText: 'emilys'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: false,
                    decoration: const InputDecoration(labelText: 'Password',hintText: 'emilyspass'),
                  ),
                  const SizedBox(height: 20),

                  // লোডিং চেক করা
                  state is LoginLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      // ইভেন্ট অ্যাড করা (Riverpod এর read এর মত)
                      context.read<LoginBloc>().add(
                        LoginSubmittedEvent(
                          username: _usernameController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}