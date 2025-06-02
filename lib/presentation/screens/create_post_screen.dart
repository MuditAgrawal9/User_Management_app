import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class CreatePostScreen extends StatefulWidget {
  final UserModel user;
  CreatePostScreen({required this.user});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Body'),
                onSaved: (val) => _body = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter body' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Post'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Here, you can store the post locally or in a provider/BLoC
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post created locally!')),
                    );
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
