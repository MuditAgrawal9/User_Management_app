import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_detail/user_detail_bloc.dart';
import '../bloc/user_detail/user_detail_state.dart';
import 'create_post_screen.dart';

/// Screen displaying detailed information about a user including:
/// - Profile information
/// - List of posts (combined local and remote)
/// - List of todos
/// - Floating action button to create new posts
class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),

      // Floating action button for creating new posts
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to CreatePostScreen while preserving the UserDetailBloc instance
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

      // Main content using BLoC state
      body: BlocBuilder<UserDetailBloc, UserDetailState>(
        builder: (context, state) {
          // Loading state
          if (state is UserDetailLoading) {
            return Center(child: CircularProgressIndicator());
          }
          // Loaded state
          else if (state is UserDetailLoaded) {
            // print('Number of posts: ${state.posts.length}');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
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

                  // Posts Section
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

                  // Todos Section
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

            // Error state
          } else if (state is UserDetailError) {
            return Center(child: Text(state.message));
          }

          // Initial state
          return SizedBox.shrink();
        },
      ),
    );
  }
}
