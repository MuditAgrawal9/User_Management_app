import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_detail/user_detail_bloc.dart';
import '../bloc/user_detail/user_detail_event.dart';
import '../bloc/user_detail/user_detail_state.dart';
import 'create_post_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<UserDetailBloc>(),
                child: CreatePostScreen(user: user),
              ),
            ),
          );
        },
      ),
      body: BlocBuilder<UserDetailBloc, UserDetailState>(
        builder: (context, state) {
          if (state is UserDetailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserDetailLoaded) {
            print('Number of posts: ${state.posts.length}');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.image),
                    ),
                    title: Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(user.email),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Posts',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...state.posts.map(
                    (post) => ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Todos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...state.todos.map(
                    (todo) => ListTile(
                      title: Text(todo.todo),
                      trailing: Icon(
                        todo.completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: todo.completed ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UserDetailError) {
            return Center(child: Text(state.message));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
