import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Apnar dynamic files gulo import korben
import '../../../../core/di/injectProvider.dart';
import '../state/add_post_state.dart';
// Jei DI file-e 'addPostViewModelProvider' create korechilen, sheta import korben

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. 🎯 BlocListener-er bodole ekhane ref.listen use korbo (Dialog, SnackBar, Navigation-er jonno)
    ref.listen<AddPostState>(addPostViewModelProvider, (previous, next) {
      if (next is PostSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post added successfully!')),
        );
        Navigator.pop(context);
      } else if (next is PostFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    // 2. 🎯 BlocBuilder-er bodole ekhane ref.watch use korbo (UI state read korar jonno)
    final state = ref.watch(addPostViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
      ),
      body: Padding(
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

            // Loading state check korchi
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
                    // 🚀 context.read-er bodole direct ref.read diye ViewModel-er method call korchi
                    ref.read(addPostViewModelProvider.notifier).submitPost(
                      title: _titleController.text,
                      userId: 5, // Apnar function-ti String type nicche state management onushare
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
      ),
    );
  }
}