import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
    title: Text('${user.firstName} ${user.lastName}'),
    subtitle: Text(user.email),
    onTap: onTap,
  );
}
