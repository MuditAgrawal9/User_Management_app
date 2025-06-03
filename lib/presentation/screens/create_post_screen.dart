import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/models/post_model.dart';
import '../bloc/user_detail/user_detail_bloc.dart';
import '../bloc/user_detail/user_detail_event.dart';

/// Screen for creating new posts locally for a specific user
class CreatePostScreen extends StatefulWidget {
  final UserModel user;
  const CreatePostScreen({super.key, required this.user});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Form key for validation and state management
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _body = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title input field
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter title' : null,
              ),

              // Body input field
              TextFormField(
                decoration: InputDecoration(labelText: 'Body'),
                onSaved: (val) => _body = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter body' : null,
              ),
              SizedBox(height: 20),

              // Submission button
              ElevatedButton(
                child: Text('Add Post'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Create a new PostModel (negative id for local)
                    final newPost = PostModel(
                      id: DateTime.now().millisecondsSinceEpoch * -1,
                      title: _title,
                      body: _body,
                    );

                    // Dispatch AddLocalPost event
                    // Notify BLoC to add the local post
                    context.read<UserDetailBloc>().add(
                      AddLocalPost(widget.user.id, newPost),
                    );

                    // Return to previous screen
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
