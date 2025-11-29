import 'package:flutter/material.dart';
import 'package:reto_obile/models/post_model.dart';
import 'package:reto_obile/services/post_service.dart';


class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _service = PostService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _service.listPosts().then((list) => list.cast<Post>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay posts'));
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.description ?? ''),
                  trailing: Text(post.companyId.toString()),
                  onTap: () {
                    // aquí podrías abrir detalles del post
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
