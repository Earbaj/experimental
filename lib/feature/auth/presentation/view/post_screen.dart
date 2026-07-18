import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Apnar dynamic files gulo import korben
import '../../../../core/di/injectProvider.dart';
import '../state/post_state.dart';
import '../viewmodel/post_viewmodel.dart'; // jekhane 'postViewModelProvider' ache
import 'add_post_screen.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 Screen initialize/open hobar sathe sathe prothom batch data trigger hobe (Ager ..add(FetchPostsEvent()) er moto)
    // ref.listen ba direct initState optimization microtask use kora jay, ekhane view binding simple rakha hoyeche
    return const PostListView();
  }
}

class PostListView extends ConsumerStatefulWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  ConsumerState<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends ConsumerState<PostListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 🚀 Screen build hobar por por prothom fetch function call korbe
    Future.microtask(() {
      ref.read(postViewModelProvider.notifier).fetchPosts();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // 🚀 Next batch fetch trigger
      ref.read(postViewModelProvider.notifier).fetchPosts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 BlocBuilder-er poriborte ekhane state structure direct watch korchi
    final state = ref.watch(postViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clean Architecture Posts')),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // UI state onushare widget load korar separate clean helper method
  Widget _buildBody(PostState state) {
    switch (state.status) {
      case PostStatus.initial:
      case PostStatus.loading:
      // Loading dynamic check: jodi ager data list-e thake tahole screen spinner na dekhay grid loading callback kaj korbe
        if (state.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildListView(state);

      case PostStatus.failure:
        if (state.posts.isEmpty) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }
        return _buildListView(state); // Fail holeo existing data dekhiye niche failure update handle kora best path

      case PostStatus.success:
        if (state.posts.isEmpty) {
          return const Center(child: Text('No posts found.'));
        }
        return _buildListView(state);
    }
  }

  Widget _buildListView(PostState state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.posts.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final post = state.posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Chip(
              label: Text('👍 ${post.likes}'),
              backgroundColor: Colors.blue.withAlpha(30),
            ),
          ),
        );
      },
    );
  }
}