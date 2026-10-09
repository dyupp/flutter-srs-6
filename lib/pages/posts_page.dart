import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_bloc.dart';
import '../models/get_posts.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Posts> posts = [];
  late PostBloc postBloc;

  @override
  void initState() {
    super.initState();
    postBloc = PostBloc();
    postBloc.add(GetPostEvent());
  }

  @override
  void dispose() {
    postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<PostBloc, PostState>(
        bloc: postBloc,
        builder: (BuildContext context, state) {
          if (state is LoadingPostState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FetchedPostsState) {
            posts = state.posts;
            return buildBody();
          }
          return const Center(
            child: Text("Some Error"),
          );
        },
      ),
    );
  }

  Widget buildBody() {
    return ListView.separated(
      itemCount: posts.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = posts[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${item.id}')),
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item.body),
        );
      },
    );
  }
}