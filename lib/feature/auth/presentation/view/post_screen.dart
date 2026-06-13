import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injectProvider.dart';
import '../block/post_bloc.dart';
import '../event/post_event.dart';
import '../state/post_state.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(key) {
    return BlocProvider(
      create: (_) => sl<PostBloc>()..add(FetchPostsEvent()),
      child: const PostListView(),
    );
  }
}

class PostListView extends StatefulWidget {
  const PostListView({Key? key}) : super(key: key);

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostBloc>().add(FetchPostsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Fetch early before hit bottom completely
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clean Architecture Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          switch (state.status) {
            case PostStatus.initial:
            case PostStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PostStatus.failure:
              return Center(child: Text('Error: ${state.errorMessage}'));
            case PostStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('No posts found.'));
              }
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
        },
      ),
    );
  }
}