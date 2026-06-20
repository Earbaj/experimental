import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostSuccess) {
            // সাকসেস হলে মেসেজ দেখিয়ে আগের পেজে ব্যাক করবে
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post added successfully!')),
            );
            Navigator.pop(context); // আগের স্ক্রিনে ফিরে যাবে
          } else if (state is PostFailure) {
            // ফেইল হলে এরর মেসেজ দেখাবে
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

                // স্টেট যদি loading হয় তাহলে বাটনের জায়গায় CircularProgressIndicator দেখাবে
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
                        // 🚀 এখানে ব্লকের Event ট্রিগার করা হচ্ছে
                        context.read<PostBloc>().add(
                          SubmitPostEvent(
                            title: _titleController.text,
                            userId: 5, // Dummy UserId
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
    );
  }
}