import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injectProvider.dart';
import '../block/add_post_block.dart';
import '../event/add_post_event.dart';
import '../state/add_post_state.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 এখানে BlocProvider দিয়ে র‍্যাপ করে দিলেন, ফলে স্ক্রিনটি বন্ধ হলে মেমরিও ফ্রী হয়ে যাবে
    return BlocProvider(
      create: (context) => sl<AddPostBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create New Post'),
        ),
        body: BlocConsumer<AddPostBloc, PostState>(
          listener: (context, state) {
            if (state is PostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post added successfully!')),
              );
              Navigator.pop(context);
            } else if (state is PostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Post Title',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your thoughts...',
                    ),
                  ),
                  const SizedBox(height: 24),

                  state is PostLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          // 🚀 এখন এই context.read টি কোনো এরর ছাড়াই ব্লক খুঁজে পাবে
                          context.read<AddPostBloc>().add(
                            SubmitPostEvent(
                              title: _titleController.text,
                              userId: 5,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a title')),
                          );
                        }
                      },
                      child: const Text(
                        'Submit Post',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
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